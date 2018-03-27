let project = new Project('New Project');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('CompileTime');
project.addLibrary('differ');
project.addLibrary('komponent2D');
project.addLibrary('yaml');
resolve(project);
