import time, subprocess, pathlib, random

def tick():
    # HOURLY MESSAGES {{{
    awake_comment = [
        #  0:00
        ["If you go to sleep now I'll pretend you went to sleep before midnight.", "/\\\nThat number is only going to get scarier now", "midnight\nquiet... so quiet..."],
        #  1:00
        ["Should probably go to sleep..."],
        #  2:00
        ["Should you really be awake?"],
        #  3:00
        ["Literally on your way to bed, right?", "Next stop:\nSleep Deprivation"],
        #  4:00
        ["Hope you're sleeping right now 👁️"],
        #  5:00
        ["If you didn't go to sleep by now... well, oops"],
        #  6:00
        ["Good morning?"],
        #  7:00
        ["Probably awake by now"],
        #  8:00
        ["hi", "hope you're not at school rn, hate that place"],
        #  9:00
        ["what are you up to?", "nine o'clock"],
        # 10:00
        ["and the day goes on...", "Next stop:\nNoon"],
        # 11:00
        ["noon soon", "12:00 any minute... well, 60 minutes away really"],
        # 12:00
        ["It is currently mid-day", "Noon reached!", "Next stop:\nAfternoon"],
        # 13:00
        ["What's for lunch?", "Lunch soon, right?", "sustenance consumption reminder"],
        # 14:00
        ["Reaching peak afternoon...", "me when 14"],
        # 15:00
        ["the afternoon", "usually the warmest time of day"],
        # 16:00
        ["What needs to get accomplished today? Should probably get on it now if there's anything urgent..."],
        # 17:00
        ["Next stop:\nEvening", "mfw 17... howwwwww"],
        # 18:00
        ["hey bby", "nooo where is the sun going wtfff 😭", "might be dinner time soon"],
        # 19:00
        ["if this isn't evening, i don't know what is", "/\\\nlook! time :o"],
        # 20:00
        ["right, so...\nin an ideal world you'd be going to sleep in 2 hours", "2 hours left\nuntil 22:00"],
        # 21:00
        ["so, going to sleep in 60 mins?", "you should start thinking about when you're going to sleep today", "time to consider sleep schedule"],
        # 22:00
        ["When are we going to sleep today?", "gnsd 👋❤️\n(who am i kidding?)"],
        # 23:00
        ["Next stop:\nMidnight (endstation)"]
    ]
    # }}}

    unixtime = int(time.time())
    localtime_tuple = time.localtime(unixtime)

    if localtime_tuple.tm_sec == 0 and localtime_tuple.tm_min == 0:
        subprocess.Popen("mpv --no-config --volume=75 --no-video {}/ac-bell/10spedup.flac".format(pathlib.Path(__file__).parent.absolute()).split(), stdout=subprocess.DEVNULL)
        subprocess.Popen(['notify-send', '-u', 'low', '-t', '17000', '{}:00'.format(localtime_tuple.tm_hour), random.choice(awake_comment[localtime_tuple.tm_hour])], stdout=subprocess.DEVNULL)

    return localtime_tuple.tm_sec

if __name__ == "__main__":
    print(tick())
