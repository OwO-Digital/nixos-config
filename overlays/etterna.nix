{ inputs, ... }:

final: prev: {
	etterna = prev.stdenv.mkDerivation rec {
	  pname = "etterna";
	  version = "0.72.3";

	  src = prev.fetchFromGitHub {
	    owner = "etternagame";
	    repo = "etterna";
	    rev = "v${version}";
		hash = "sha256-t+orXcnEZWotFWTum1t5SRpnBG+Lx5pRz91VkFk/z2M=";
	  };

	  #patches = [ ./0001-fix-build-with-ffmpeg-4.patch ];

	  nativeBuildInputs = with prev; [ cmake nasm ];

	  buildInputs = with prev; [
	    gtk2
	    glib
	    ffmpeg
	    alsa-lib
	    libmad
	    libogg
	    libvorbis
	    glew
	    libpulseaudio
	    udev
	    openssl
	  ];

	  cmakeFlags = [
	    "-DCMAKE_BUILD_TYPE=Release"
	    "-DWITH_SYSTEM_FFMPEG=1"
	    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${prev.gtk2.out}/lib/gtk-2.0/include"
	    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${prev.glib.out}/lib/glib-2.0/include"
	    "-DWITH_CRASHPAD=OFF"
	  ];

	  postPatch = ''
		echo \"
find_path(PULSEAUDIO_INCLUDE_DIR
    NAMES pulse/pulseaudio.h
    DOC "The PulseAudio include directory"
)

find_library(PULSEAUDIO_LIBRARY
    NAMES pulse
    DOC "The PulseAudio library"
)

target_link_libraries(Etterna PRIVATE pulse-simple)
target_link_libraries(Etterna PRIVATE pulse)
	  \" >> $src/CMakeLists.txt
	  '';

	  postInstall = ''
	    mkdir -p $out/bin
	    ln -s $out/Etterna $out/bin/Etterna
	  '';

	  meta = with prev.lib; {
	    homepage = "https://www.etternaonline.com/";
	    description = "Free dance and rhythm game for Windows, Mac, and Linux";
	    platforms = platforms.linux;
	    license = licenses.mit; # expat version
	    maintainers = [ ];
	  };
	};
}
