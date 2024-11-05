from monitorcontrol import get_monitors


def app() -> None:
    for monitor in get_monitors():
        with monitor:
            try:
                print(monitor.get_luminance())
            except Exception as e:
                print(e)
