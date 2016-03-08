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

4. If you use the **--test** argument it is assumed that the class that the unit tests will go in is named by convension <className>TestSutie and uses the same file extensions. That is if the class I'm adding a property to is called *MyTestClass.h/MyTestClass.cpp* then I assumed that the class which holds the tests for MyTestClass is called *MyTestClassTestSuite.h/MyTestClassTestSuite.cpp*.

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


#### Number of Tabs Used

The tool by default will use 1 tab when indenting methods, variables, and macros. The default is geared towards a header file which defines one class with no
namespace. 

> <pre>class MyClass **<- Zero tabs in**
> {
> public:	
>     \tMyClass() {} **<-- One tabs in**
> };</pre>	

If however you are using namespaces *and* you indent your class definition within the namespace you can override the default number of tabs used
to properly align the newly added methods, variables, and macros by using the **--tab=<num>** argument.

##### Example
> $ ruby genprop.rb MyTestClass temp:double --tab=2

The above would align any *private:, public:, signals:* keywords one tab level in and any added macros, signals, methods, or variables **2** tabs in. One would do this if they have their class indented within a signle namespace.

> <pre>namespace MyNamespace **<-- Zero tabs in**
> {
>    class MyClass **<- One tab in**
>    {
>    public:	
>        MyClass() {} **<-- Two tabs in**
>    };	
> }</pre>

The number of tabs can not be less then 1 but can be as large as needed. If you enter a tab value of 0 or less the tool will adjust it to 1 tab to ensure the tool can still function.

#### Unit Tests

The tool can also be used to auto-generate a number of unit tests for the newly added property. To do this use the optional **--test** argument.

##### Example
> $ ruby genprop.rb MyTestClass tmep:double --test

The above will generate a few typical unit tests to cover the newly added property. Unit tests will be added to a class called *<className>TestSuite* so for the above example the tool will try to inject the new unit tests into a class called *MyTestClassTestSuite.hpp/.cpp*. It will look for the test suite class in the same directory as MyTestClass.

Note that the unit tests may not compile as the auto generated unit tests will use default constructors when instanshating your class (i.e. MyTestClass) and the properties type class. You may still need to fix up the objects used in the test.

#### Unit Tests Path

Your unit test code may not be within the same directory as your production code. For example you might have put all your unit test code under a sub folder called */unittests*. By default the tool will look in the same directory as the production code (i.e. MyTestClass). to override this you can use the **--test.path=<path>** argument.

##### Example
> $ ruby genprop.rb MyTestClass tmep:double --test.path=unittest

You can use relative paths or absolute paths. So if your unit tests are at the same level as your producation code in a parallel folder you can use:

> $ ruby genprop.rb MyTestClass tmep:double --test.path=../unittest

Notice that you do not need to use both *--test* and *--test.path=<path>* using the path argument on its own impies that the *--test* argument is to be used.


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

#### Source File Extension
By default the tool assumes your source file will be using the extension *cpp*. If your source file is using another extension, such as *cxx*, you can override the default with the command line flag **--source.ext=*extention***

##### Example
> $ ruby genprops.rb MyTestClass.hxx --source.ext=cxx

The above would read the MyTestClass.hxx file and inject the required code into the MyTestClass.hxx and MyTestClass.cxx files.
**Note that the tool uses the header file extension you typed in when you told it what header file to read from.**

#### Number of Tabs Used

The tool by default will use 1 tab when indenting methods, variables, and macros. The default is geared towards a header file which defines one class with no
namespace. 

> <pre>class MyClass **<- Zero tabs in**
> {
> public:	
>     \tMyClass() {} **<-- One tabs in**
> };</pre>	

If however you are using namespaces *and* you indent your class definition within the namespace you can override the default number of tabs used
to properly align the newly added methods, variables, and macros by using the **--tab=<num>** argument.

##### Example
> $ ruby genprop.rb MyTestClass temp:double --tab=2

The above would align any *private:, public:, signals:* keywords one tab level in and any added macros, signals, methods, or variables **2** tabs in. One would do this if they have their class indented within a signle namespace.

> <pre>namespace MyNamespace **<-- Zero tabs in**
> {
>    class MyClass **<- One tab in**
>    {
>    public:	
>        MyClass() {} **<-- Two tabs in**
>    };	
> }</pre>

The number of tabs can not be less then 1 but can be as large as needed. If you enter a tab value of 0 or less the tool will adjust it to 1 tab to ensure the tool can still function.

### Things to Know

1. Right now if the tool successfully injects code into the header file but fails to inject code into the source file then your header file will indeed be modified. If you run the tool again after fixing whatever blocked the source file you will get duplicate entries in your header file.

2. Right now if your using namespaces the tab-ing of the injected code in your header file won't be right. It assumes no namespace when it comes to tabbing so the generated code is only tabbed in once. I want to fix this in a later version as I do use namespaces often.


# Install -- Linux

On linux to have it so that you can run the above commands from anywhere you can install a symlink into your path which points to the script.

First find what locations are already in your path:

> $ echo $PATH

You can add a new location or use one of these. I'm going to use an existing location.

I could copy the code into one of those locations or I could setup a symlink, I'm going to show you how to do this with a symlink.

In a terminal navigate to the location you cloned the code to; In my case this is *~/Development/qt_property_generator*

From there type:
> $ ln -s ~/Development/qt_property_generator/genprop.rb /usr/local/bin/genprop<br/>
> $ ln -s ~/Development/qt_property_generator/genprops.rb /usr/local/bin/genprops

The above will create two symlinks which point to each of the ruby scripts in a location within my PATH. Notice that my symblinks don't include the file extension so I can now type the following from any location:

> $ ruby genprop --help
