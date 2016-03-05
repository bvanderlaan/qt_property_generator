# Qt Property Generator
This is a tool that will read a C++ header file for Q_PROPERTY entries then generate the required getters/setters and signals needed
to implement said property.

to use the tool in a termial type:
> $ ruby generate_qt_property.rb *header file*

## Example
> $ ruby generate_qt_property.rb MyTestClass.hpp

The above command would read the MyTestClass.hpp file and look for all Q_PROPERTY entries. For each Q_PROPERTY entry found it will inject the neccessary method
implementation into the source file and the neccessary definitions into the header file.

### Assumptions
1. Namespaces are supported but its assumed that your using the *using* keyword for all namespaces in your source file as the injected method implementation
will simply be appended to the end of the source file.
2. The tool assumes that **NO** Q_PROPERTY entries have implementations so if you run the tool twice you will get duplicate definitions/implementations injected 
into your header and source files.