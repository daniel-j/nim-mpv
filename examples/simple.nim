import os
import mpv

proc main(): int =
  result = 1
  
  if paramCount() != 1:
    echo "pass a single media file as argument"
    return

  let ctx = mpv.create()
  if ctx.isNil:
    echo "failed creating mpv context"
    return
  defer: mpv.terminate_destroy(ctx)

  # Enable default key bindings, so the user can actually interact with
  # the player (and e.g. close the window).
  ctx.set_option("terminal", "yes")
  ctx.set_option("input-default-bindings", "yes")
  ctx.set_option("input-vo-keyboard", "yes")
  ctx.set_option("osc", true)

  # Done setting up options.
  check_error ctx.initialize()

  # Play this file.
  ctx.command("loadfile", paramStr(1))

  while true:
    let event = ctx.wait_event(10000)
    echo "event: ", mpv.event_name(event.event_id)
    if event.event_id == mpv.EVENT_SHUTDOWN:
      break

  return 0


system.quit(main())
