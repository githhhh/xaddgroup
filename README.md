# XAddGroup

批量创建Group 到 xcodeproj, 包括对应的实体Dir

# Example

Help
> $ XAddGroup --help

Use:

> $ cd 项目根目录
> 
> $ XAddGroup  path-to/newDir 

Just Create newDir

> $ cd 项目根目录
> 
> XAddGroup  -b  path-to/newDir 

Created:

```
* newDir
	* Model
	* View
	* ViewModel
	* ViewController
	* Request
```

# Requirements

[Xcodeproj](https://github.com/CocoaPods/Xcodeproj)








