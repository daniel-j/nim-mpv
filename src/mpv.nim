import nimterop/[cimport]

static:
  # cDebug()  # Print wrapper to stdout
  cAddStdDir("c")
  cSkipSymbol(@["mpv_opengl_drm_params", "mpv_opengl_drm_params_v2",
      "mpv_opengl_drm_draw_surface_size", "mpv_opengl_drm_osd_size"])

const
  clientPath = cSearchPath("mpv/client.h")
  renderPath = cSearchPath("mpv/render.h")
  renderGLPath = cSearchPath("mpv/render_gl.h")

cImport(
  filenames = @[clientPath, renderPath, renderGLPath],
  recurse = true,
  flags = "-f:ast2 --prefix=mpv_ --prefix=MPV_ --prefix=_ --suffix=_ --noComments"
)

{.passL: "-lmpv".}

# Helpers
proc check_error*(status: cint) =
  if status < 0:
    raise newException(CatchableError, "mpv error: " & $mpv.error_string(status))


proc set_option*(ctx: ptr handle, name: string, value: bool) =
  var val = cint value
  check_error ctx.set_option(name, mpv.FORMAT_FLAG, val.addr)
proc set_option*(ctx: ptr handle, name: string, value: string) =
  check_error ctx.set_option_string(name, value.cstring)

proc get_property*(ctx: ptr handle, name: string): string =
  var val: cstring
  check_error ctx.get_property(name, mpv.FORMAT_STRING, val.addr)
  return $val

proc set_property*(ctx: ptr handle, name: string, value: string) =
  var val = cstring value
  check_error ctx.set_property(name, mpv.FORMAT_STRING, val.addr)
proc set_property_async*(ctx: ptr handle, reply_userdata: uint64 = 0,
    name: string, value: string) =
  var val = cstring value
  check_error ctx.set_property_async(reply_userdata, name, mpv.FORMAT_STRING, val.addr)


proc command*(ctx: ptr handle, args: varargs[string]) =
  let cmd = allocCStringArray(@args)
  defer: deallocCStringArray(cmd)
  check_error ctx.command(cmd[0].addr)
proc command_async*(ctx: ptr handle, reply_userdata: uint64 = 0, args: varargs[string]) =
  let cmd = allocCStringArray(@args)
  defer: deallocCStringArray(cmd)
  check_error ctx.command_async(reply_userdata, cmd[0].addr)
