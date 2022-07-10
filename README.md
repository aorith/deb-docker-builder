Generate simple debian binary packages.  

* [new-recipe.sh](new-recipe.sh) creates the skeleton of a new recipe to build a package.  
* [build.sh](build.sh) builds a package from one of the existing recipes.  

The contents of `recipes/<package_name>/<tag>` will be mounted read-only to `/recipe-ro`
inside of the build docker container and copied over to `/recipe` too.  
Then, all the bash scripts found at `/recipe/build/scripts` will be executed in
order, when those scripts finish the contents of `/recipe/package` will be built
into a .deb file.  

Check [recipes/hello-world/bullseye](./recipes/hello-world/bullseye) for an example.  

