# docker-multimon
Docker container to build a patched Debian package binary that fixes incompatibilities between multimon and newer versions of sox


## Usage
1. run 'make' to build the container images
   the build command will build the patched .deb package in the multimon container and deposit it in the ./debfile folder.
   the 'oldsox' service builds an older version of sox which supports the deprecated arguments and can be used to figure out the equivalent arguments in the newer builds.
   the 'soxtest' service installs the patched multimon package and sox to test the compatibility between the two.

2. run 'make man' to view the man file from the 'oldsox' service

3. run 'make test' to run the 'soxtest' service and test the functionality of the patched multimon version.

## Details
Two files invoke 'sox':
	gen.c
	unixinput.c

They both use two deprecated arguments which have been removed in current versions of sox: "-s" and "-2".
The fix is to substitute the newer equivalents into the calls in those two source files and things will work as intended.

Aruments:
OLD
"-s"	=>	"-e signed-integer"
"-2"	=>	"-r 16"

see the *.patch files for specific changes.


