module Pair
  class Session
    class AuthorizedKeysFile
      ACCESS_TYPE = "type"
      KEYS        = "keys"

      attr_accessor :member_keys
      attr_accessor :session
      attr_accessor :key_file_path

      def initialize(member_keys = {}, session)
        self.member_keys = member_keys
        self.session = session
        self.key_file_path = File.expand_path("~/.ssh/authorized_keys")
      end

      def install
        return nil if self.member_keys.values.empty? || self.member_keys.values.map { |k,v| v }.empty?

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

      def line_numbers_of(key)
        `grep -ns ".*#{key}.*" #{self.key_file_path} | sed 's/\:.*//'`.split('\n').map(&:strip)
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
        keys.each do |key|
          in_file.puts "command=\"#{command(session, of_type)}\",#{key_options.join(',')} #{key["content"]} #id:#{key["id"]}"
        end
        in_file.puts ""
      end

      def command(session, type)
        options = ["-S /tmp/pairmill/tmux-#{session.name} attach"]
        options << "-r" if type == 'viewer'

        "/usr/local/bin/tmux #{options.join(' ')}"
      end

      def key_options
        %w{no-port-forwarding no-X11-forwarding no-agent-forwarding}
      end
    end
  end
end
