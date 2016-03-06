# Qt Property Generator
This is a tool to help automate the cration of Qt properties.

Implementing properties in Qt is pretty streight forward but tediusly repetative. This tool will automate the activity so you can focuse on the core
buisness logic you need to implement.

There are two flavours of the tool, one that reads the Q_PROPERTY entries of an existing header file and generates the required getters/setters and signals needed; and another which will generate the code needed to implement a signle property including the Q_PROPERTY macro.

## Generate One New QPROPERTY

If you have not yet written any C++ code for your **new** property, that is you have not yet added a signal, implemented getters/setters or defined the Q_PROPERTY macro then you can use this version of the tool to generate not only the required getters/setters and signals for a given property but also the Q_PROPERTY entry as well. Note you can use this tool on a class which already has Q_PROPERTIES or other C++ code as long as the propety your getting this tool to generate won't conflix with any existing code. It won't overwrite anything but your code won't compile.

To use this tool open a terminal and type:
> $ ruby genprop.rb *class name* *property name*:*property type*

### Example
> $ ruby genprop.rb MyTestClass temp:double

The above will crate a read/write property named **temp** of type **double**.
This will generate the neccissary getter and setter, will define the required signal and member variable as well as define the Q_PROPERTY macro for the property. The generated code will be injected into MyTestClass.hpp and MyTestClass.cpp

### Assumptions
1. Namespaces are supported but its assumed that your using the *using* keyword for all namespaces in your source file as the injected method implementation will simply be appended to the end of the source file.

2. This tool assumes the property name you gave it does not already exist in the class. If it does you will get duiplicate entries.

3. The tool assumes that the header and source files will have the same name as the class name you provided it.

### Options

#### Source File Extension
By default the tool assumes your source file will be using the extension *cpp* and that your header file will be using the extension *hpp*. 

If your source file is using another extension, such as *cxx*, you can override the default with the command line flag **--source.ext=*extension***

##### Example
> $ ruby genprop.rb MyTestClass temp:double --source.ext=cxx

The above would inject the required code into the MyTestClass.hpp and MyTestClass.cxx files.

#### Header File Extension
If your header file is using an extension other then hpp then you can override the default with the command line flag **--header.ext=*extension***

##### Example
> $ ruby genprop.rb MyTestClass temp:double --header.ext=hxx

The above would inject the required code into the MyTestClass.hxx and MyTestClass.cpp files.

The above flags can be used together.

##### Example
> $ ruby genprop.rb MyTestClass temp:double --header.ext=hxx --source.ext=cxx

The above would inject the required code into the MyTestClass.hxx and MyTestClass.cxx files.

#### Read-Only Properties

The tool by default will implement a read-write property complete with property binding protection. If you desire a read-only property then you can use the command line flag **--readonly** to tell the tool to only generate the getter and defined the Q_PROPERTY as a read-only property.

##### Example
> $ ruby genprop.rb MyTestClass temp:double --readonly


### Things to Know

1. Right now if the tool successfully injects code into the header file but fails to inject code into the source file then your header file will indeed be modified. If you run the tool again after fixing whatever blocked the source file you will get duplicate entries in your header file.

2. Right now if your using namespaces the tab-ing of the injected code in your header file won't be right. It assumes no namespace when it comes to tabbing so the generated code is only tabbed in once. I want to fix this in a later version as I do use namespaces often.

===

## Generate Multiple QPROPERTIES

If you have already written out a bunch of Q_PROPERTY macros and are now looking at having to implement the getters/setters and signals for each use this version of the tool.

To use the tool open a terminal and type:
> $ ruby genprops.rb *header file*

**Notice that this is the plural form of the tool.**

### Example
> $ ruby genprops.rb MyTestClass.hpp

The above command would read the MyTestClass.hpp file and look for all Q_PROPERTY entries. For each Q_PROPERTY entry found it will inject the neccessary method implementation into the source file and the neccessary definitions into the header file.

### Assumptions
1. Namespaces are supported but its assumed that your using the *using* keyword for all namespaces in your source file as the injected method implementation will simply be appended to the end of the source file.

2. The tool assumes that **NO** Q_PROPERTY entries have implementations so if you run the tool twice you will get duplicate definitions/implementations injected into your header and source files.

3. The tool assumes that the source file will have the same name as the header file and that the class name is the same as your file name.

### Options
By default the tool assumes your source file will be using the extension *cpp*. If your source file is using another extension, such as *cxx*, you can override the default with the command line flag **--source.ext=*extention***

#### Example
> $ ruby genprops.rb MyTestClass.hxx --source.ext=cxx

The above would read the MyTestClass.hxx file and inject the required code into the MyTestClass.hxx and MyTestClass.cxx files.
**Note that the tool uses the header file extension you typed in when you told it what header file to read from.**

### Things to Know

1. Right now if the tool successfully injects code into the header file but fails to inject code into the source file then your header file will indeed be modified. If you run the tool again after fixing whatever blocked the source file you will get duplicate entries in your header file.

2. Right now if your using namespaces the tab-ing of the injected code in your header file won't be right. It assumes no namespace when it comes to tabbing so the generated code is only tabbed in once. I want to fix this in a later version as I do use namespaces often.