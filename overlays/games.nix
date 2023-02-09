{inputs, ...}:

final: prev:
{
	etterna = prev.stdenv.mkDerivation rec {
		pname = "etterna";
		version = "0.72.1";

		src = prev.fetchFromGitHub {
			owner = "etternagame";
			repo = "etterna";
			rev = "v${version}";
			sha256 = "sha256-HWUmrNBPxKWHs5bJy4S6nS7OjvwqziwAjlXkyzSA7Ak=";
		};

		nativeBuildInputs = with prev; [cmake nasm];

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
			"-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
			"-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
			"-DWITH_CRASHPAD=OFF"
		];

		postInstall = ''
			mkdir -p $out/bin
			ln -s $out/Etterna $out/bin/Etterna
		'';

		meta = with prev.lib; {
			homepage = "https://www.etternaonline.com/";
			description = "Free dance and rhythm game for Windows, Mac, and Linux";
			platforms = platforms.linux;
			license = licenses.mit;
			maintainers = [];
		};
	};
}
