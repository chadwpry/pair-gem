module Pair
  class Session
    # TODO replace with authorized_keys gem
    class AuthorizedKeysFile
      ACCESS_TYPE = "type"
      KEYS        = "keys"

      attr_accessor :member_keys
      attr_accessor :attach_command
      attr_accessor :key_file_path

      def initialize(member_keys, attach_command)
        self.member_keys    = member_keys || {}
        self.attach_command = attach_command
        self.key_file_path  = File.expand_path("~/.ssh/authorized_keys")
      end

      def install
        return if member_keys.empty?

        backup_authorized_keys if key_file_exists?
        create_authorized_keys
      end

      def cleanup
        cleanup_authorized_keys
      end

      def cleanup_authorized_keys
        remove_existing_file
        move_backup_file if backup_key_file_exists?
      end

      def backup_authorized_keys
        puts "Backing up authorized_keys: #{self.key_file_path}" if $-d
        FileUtils.cp(self.key_file_path, backup_key_file_path)
      end

      def remove_existing_file
        puts "Removing authorized_keys: #{self.key_file_path}" if $-d
        FileUtils.rm(self.key_file_path)
      end

      def move_backup_file
        puts "Moving backup: #{self.backup_key_file_path}" if $-d
        FileUtils.mv(backup_key_file_path, self.key_file_path)
      end

      def key_file_exists?
        File.exists? self.key_file_path
      end

      def backup_key_file_exists?
        File.exists? backup_key_file_path
      end

      def backup_key_file_path
        "#{self.key_file_path}.pair"
      end

      private

      def create_authorized_keys
        File.open(self.key_file_path, 'w') do |file|
          self.member_keys.each do |user, hash|
            write_comment_for user, file
            write_rows_for hash[KEYS], hash[ACCESS_TYPE], file
          end
        end

        self.key_file_path
      end

      def write_comment_for user, in_file
        in_file.puts "# #{user}"
      end

      def write_rows_for keys, of_type, in_file
        read_only = of_type == 'viewer'

        keys.each do |key|
          command = attach_command[read_only].join(' ').inspect

          options = ["command=#{command}", *key_options].join(',')
          content = key["content"]
          comment = "# id: #{key["id"]}"

          in_file.puts [options, content, comment].join(' ')
        end
        in_file.puts ""
      end

      def key_options
        %w{no-port-forwarding no-X11-forwarding no-agent-forwarding}
      end
    end
  end
end
