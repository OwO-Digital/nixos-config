import json
from ha_mqtt_discoverable import Settings, DeviceInfo
from ha_mqtt_discoverable.sensors import Light, LightInfo
from paho.mqtt.client import Client, MQTTMessage

# Configure the required parameters for the MQTT broker
mqtt_settings = Settings.MQTT(host = "192.168.1.103")

device_info = DeviceInfo(name="desktop", identifiers="foo1bar2")

# Information about the light
light_info = LightInfo(
    name="brightness",
    unique_id="bar3foo4",
    device=device_info,
    brightness=True,
)

settings = Settings(mqtt=mqtt_settings, entity=light_info)

# To receive state commands from HA, define a callback function:
def my_callback(client: Client, user_data, message: MQTTMessage):

    # Make sure received payload is json
    try:
        payload = json.loads(message.payload.decode())
    except ValueError as error:
        print("Ony JSON schema is supported for light entities!")
        return

    # Parse received dictionary
    if "brightness" in payload:
        print(payload["brightness"])
        my_light.brightness(payload["brightness"])
    elif "state" in payload:
        if payload["state"] == light_info.payload_on:
            print("on")
            my_light.on()
        else:
            print("off")
            my_light.off()
    else:
        print("Unknown payload")


my_light = Light(settings, my_callback)

def app() -> None:
    my_light.off()