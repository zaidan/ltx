# ltx - LaTeX Project Build Tool

This project provides the ltx command. It reads your `project.yml` and
compiles your LaTeX files to a tmp folder in your project subdirectory.  This
does not mess your project with temporary files and simplifies the clean up
procedure. It also let you define a project specific file name with optional
version number and version prefix.

## Example project.yml

```yaml
title: Your Name - Some Project
version: 1.0.0
version_prefix: ' v'
main: main.tex
compiler: pdflatex
```

## Credits

 * [Firas Zaidan](https://github.com/zaidan)

## License

See `LICENSE` file.
