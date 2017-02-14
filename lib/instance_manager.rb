# frozen_string_literal: true
class InstanceManager
  EC2_INSTANCE_ID = ENV.fetch('EC2_INSTANCE_ID')

  def initialize
    @ec2 = Aws::EC2::Client.new(region: ENV.fetch('EC2_REGION'),
                                credentials: Aws::Credentials.new(ENV.fetch('EC2_ACCESS_KEY_ID'),
                                                                  ENV.fetch('EC2_SECRET_ACCESS_KEY')))
  end

  # TODO: solve AWS permission problem
  def running?
    @ec2
      .describe_instance_status(instance_ids: [EC2_INSTANCE_ID])
      .to_h[:instance_statuses]
      .map { |a| a[:instance_id] }
      .include?(EC2_INSTANCE_ID)
  end

  def start
    @ec2.start_instances(instance_ids: [EC2_INSTANCE_ID])
  end

  def stop
    @ec2.stop_instances(instance_ids: [EC2_INSTANCE_ID])
  end
end
