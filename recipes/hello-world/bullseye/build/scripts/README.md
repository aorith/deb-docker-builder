Scripts or binaries with execution permissions is this directory will be executed in order inside of the container.  
If all the scripts are ran successfully the contents of /recipe/package (which should  
be a valid debian binary package after the scripts execution) will be built as a debian package using 'dpkg-deb'.  
