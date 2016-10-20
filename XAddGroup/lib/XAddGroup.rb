require "xcodeproj"
require 'fileutils'

class XAddGroup

	def self.createRealFinder (newgroup)
		groupPath =  newgroup.real_path
		begin
			FileUtils::mkdir_p groupPath  unless File.exists?(groupPath)
			puts groupPath 
		rescue Exception => e
			raise "无法创建实体文件夹:" + e 
		end
	end

	def self.addToGroupFile (newgroup,fileName)
		new_file_refs = Array.new(2)
		file_h_path = [File.join(newgroup.real_path,fileName),'h'].join('.').to_s
		file_m_path = [File.join(newgroup.real_path,fileName),'m'].join('.').to_s

		new_file_refs[0] = newgroup.new_reference(file_h_path)
		new_file_refs[1] = newgroup.new_reference(file_m_path)
		#创建源文件
		begin
			for file_ref in new_file_refs
				File.new(file_ref.real_path,'w') unless File.exists?(file_ref.real_path)
			end 
		rescue Exception => e
			raise e
		end
	end
    

	def self.run(arg)
		
		cmp = ''
		arg_dir_new = ''
		#检查参数。。
		if arg.count == 0
			puts "[!] Miss option paramter"
		    puts ""
			puts "\t Did you mean: --help?"
			exit
		elsif arg.count == 1 
			if arg[0] == "--help"
				puts "Usage:"
			    puts "\t $ XAddGroup COMMAND"
			    puts "\t Batch Add Group To Xcodeproj,And map Entity Directory ."
			    puts "Commands:"
			    puts "\t XAddGroup <group-path>        - 在当前项目根目录 查找<group-path>,如果没对应目录则默认创建"
			    puts "\t XAddGroup -b <group-path>     - 在<group-path>目录下 批量生成子目录:'Model','View','ViewModel','ViewController','Request'"
			    exit
			elsif arg[0] != '-b'  && arg[0].to_s.include?('-')
			    puts "[!] Unknown option: '#{arg[0]}'"
			    puts ""
				puts "\t Did you mean: --help?"
				exit
			elsif arg[0] == '-b'
				puts "[!] Miss Target dir_path"
			    puts ""
				puts "\t Did you mean: --help?"
				exit
			elsif 
				arg_dir_new = arg[0]									
			end

		elsif arg.count == 2

			if arg[0].to_s != "--help" && arg[0].to_s != "-b"
				puts "[!] Unknown option: '#{arg[0]}'"
			    puts ""
				puts "\t Did you mean: --help?"
				exit					
			end

			cmp = arg[0]
			arg_dir_new = arg[1]
		end


		#find xcodeproj
		xprojs =  Dir.glob('*.xcodeproj').select {|item| 'Pods.xcodeproj' != item }
		exit unless xprojs.count == 1
		xprojName =  xprojs[0]

		#自定义子目录
		custom_mvvm_dirs = ['Model','View','ViewModel','ViewController','Request']


		#创建Xcodeproj 对象
		project = Xcodeproj::Project.open(xprojName)

		#创建group
		new_groups = Array.new(0)

		if cmp == '-b'
			custom_mvvm_dirs.each do |mvvm_dirName|
				new_group_ref = project.main_group.find_subpath(File.join(arg_dir_new,mvvm_dirName),true)
				new_groups.push(new_group_ref)
		    end
		else
			begin
				group_ref =  project.main_group.find_subpath(File.join(arg_dir_new),true)
				new_groups.push(group_ref)
			rescue Exception => e
				raise e
			end
		end

		# puts ["cmp",cmp].join("===>") 
		# puts ["arg_dir_new",arg_dir_new].join("===>") 
		# puts ["new_groups",new_groups].join("===>") 
		# puts ["new_groups[0].class",new_groups[0].class].join("===>") 
		# puts ["new_groups.class",new_groups.class].join("===>") 

		# 设置 group set_source_tree  set_path
		new_groups.each do |group|
		    #往上查找，并设置实际path
		    pre_path = ""
			group.parents.each do |parentGroup|
				# puts ["parentGroup.display_name",parentGroup.display_name].join("===>")
				if parentGroup.display_name == 'Main Group'
					next
				end
				if pre_path == ""
					pre_path = parentGroup.display_name
				else
					pre_path = [pre_path,parentGroup.display_name].join('/') 
				end
				#设置实际路径
				parentGroup.set_source_tree('SOURCE_ROOT')
				parentGroup.set_path(pre_path)
			end

			#设置实际路径
			# puts ["group.display_name",group.display_name].join("===>")
			if pre_path == ""
			    pre_path = group.display_name
			else
				pre_path = [pre_path,group.display_name].join('/') 
			end
			# puts ["pre_path",pre_path].join("===>")
			group.set_source_tree('SOURCE_ROOT')
			group.set_path(pre_path)

			#创建group实体
			createRealFinder(group)
		end

		#添加文件到group
		# new_file_refs = addToGroupFile(group,'Test')

		#添加源文件引用到target
		# project.targets.first.add_file_references(new_file_refs)
		#保存并重新加载
		project.save
	end
end 