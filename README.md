# XAddGroup

A Ruby gem .  Batch Add Group To Xcodeproj , Include Real Dir.

# Install

```
$ gem install XAddGroup
$ XAddGroup --help
```
# Example 

Just Create newDir :

```
$ cd project-rootDir
$ XAddGroup  path-to/newDir
```
Batch Create Directorys :

```
* newDir
	* Model
	* View
	* ViewModel
	* ViewController
	* Request
```

```
$ cd project-rootDir
$ XAddGroup -b  path-to/newDir
```
# Requirements

[Xcodeproj](https://github.com/CocoaPods/Xcodeproj)


# 发布首个Gem 不得不说的坑

环境:

```
❯ ruby --version
ruby 2.0.0p643 (2015-02-25 revision 49749) [x86_64-darwin14.3.0]

❯ gem --version
2.6.7

❯ gem sources                                                                                                                                     [15:08:54]
*** CURRENT SOURCES ***

https://rubygems.org/
```

以下步骤解决

```
SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
```

#### 1、更新系统 gem :
先在终端翻墙 , 以蓝灯为例,确保启动蓝灯:
查看 系统偏好设置->网络->当前wifi ->高级 ->代理 -> 自动代理配置

```
 http://127.0.0.1:16823/proxy_on.pac?1476947698880045626
```

在终端导入 

```
export http_proxy=http://localhost:16823
export https_proxy=http://localhost:16823
```

验证 

```
 $ curl google.com
   下面一坨html,说明你成功了。
```
 
```
 $ gem update --system
 $ gem -v
```

重启终端或重新打开一个终端窗口, 不然会影响最后的gem发布 

#### 2、替换rubygems.org 证书

下载 [AddTrustExternalCARoot-2048.pem](https://github.com/smalruby/smalruby-installer-for-windows/blob/master/Ruby216_32/lib/ruby/2.1.0/rubygems/ssl_certs/AddTrustExternalCARoot-2048.pem). 
  
```
$ gem which rubygems
/Users/user_name/.rvm/rubies/ruby-2.0.0-p643/lib/ruby/site_ruby/2.0.0/rubygems.rb
```
   替换下面目录中的 AddTrustExternalCARoot-2048.pem
   
```
 /Users/user_name/.rvm/rubies/ruby-2.0.0-p643/lib/ruby/site_ruby/2.0.0/rubygems/ssl_certs/ 
```
 https://gist.github.com/luislavena/f064211759ee0f806c88

#### 3、更新OpenSSL security certificates

```
$ brew tap raggi/ale

$ brew install openssl-osx-ca

$ brew link makedepend

$ brew services start raggi/ale/openssl-osx-ca
```

https://github.com/rubygems/rubygems/issues/665

#### 4、发布gem 🍺🍺

登录rubygems.org

```
$ curl -u your_rubygems_org_name https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials
```

下次不用登录直接push 就可以了

```
$ gem push -v  path-to/XAddGroup-0.5.0.gem

	GET https://api.rubygems.org/latest_specs.4.8.gz
	200 OK
	Pushing gem to https://rubygems.org...
	POST https://rubygems.org/api/v1/gems
	200 OK
	Successfully registered gem: XAddGroup (0.5.0)
```




