function suite_fry-config
	function setup
		stub_var fry_auto_switch 0
		stub_var fry_rubies /tmp/rubies
		stub_var fry_installer installer
	end

	function test_empty_arguments
		assert (fry-config)
		assert_includes (fry-config help) (fry-config)
	end

	function test_help
		set -l auto_output (fry-config auto)
		set -l path_output (fry-config path)
		set -l installer_output (fry-config installer)

		for arg in help --help -h
			set -l output (fry-config $arg)

			assert_equal 0 $status
			assert_match $auto_output $output
			assert_match $path_output $output
			assert_match $installer_output $output
			assert_includes 'usage: fry config <name> [<value>]' $output
			assert_includes 'Available configuration:' $output
		end
	end

	function test_path_config
		for command in path rubies
			assert_equal 'Path: /tmp/rubies' (fry-config $command)
			assert_equal 'Path: /tmp/rubiez' (fry-config $command /tmp/rubiez)
			assert_equal $fry_rubies /tmp/rubiez
			set fry_rubies /tmp/rubies
		end
	end

	function test_auto_switch_config
		assert_equal 'Auto-Switch: off' (fry-config auto)

		assert_equal 'Auto-Switch: on' (fry-config auto on)
		assert_equal $fry_auto_switch 1

		assert_equal 'Auto-Switch: off' (fry-config auto off)
		assert_equal $fry_auto_switch 0

		assert_equal 'Auto-Switch: on' (fry-config auto 1)
		assert_equal $fry_auto_switch 1

		assert_equal 'Auto-Switch: off' (fry-config auto 0)
		assert_equal $fry_auto_switch 0
	end

	function test_installer_config
		assert_equal 'Installer: installer' (fry-config installer)
		assert_equal 'Installer: new_installer' (fry-config installer new_installer)
		assert_equal $fry_installer new_installer
	end
end

if not set -q tank_running
	source (dirname (status -f))/helper.fish
	tank_run
end
