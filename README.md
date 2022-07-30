> Generate simple debian binary packages.  

* [new-recipe.sh](new-recipe.sh) creates the skeleton of a new recipe to build a package.  
* [build.sh](build.sh) builds a package from one of the existing recipes.  

When building a package the contents of `recipes/<package_name>/<tag>` will be available inside of the container in two directories:   

- `/recipe-ro` a read-only bind mount  
- `/recipe` a copy of the contents, *scripts* should do its work here  

All the *scripts* or binaries with execution permissions found at `/recipe/build/scripts` (which would be `recipes/<package_name>/<tag>/build/scripts` outside of the container) will be executed in order.   
When those *scripts* finish the contents of `/recipe/package` will be built into a `.deb` file and saved to the `output/` directory outside of the container.  

The `DEBIAN/control` file should include:  

```
Package: <package_name>
Version: <package_version>
Architecture: <arch>
Maintainer: <name/email>
Depends: <dependencies> (optional but recommended)
Description: <description>
```

Check [recipes/hello-world/bullseye](./recipes/hello-world/bullseye) for an example.  
