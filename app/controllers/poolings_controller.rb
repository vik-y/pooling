class PoolingsController < ApplicationController
	before_filter :admin_required

	def index
		pl = PartitionUtils.new.info.to_a
		@partitions = pl.delete_if do |p|
			p[:bytes_free] < 200.megabytes and not DiskPoolPartition.find_by_path(p[:path])
		end
		dppl = DiskPoolPartition.all.to_a
		@broken_disk_pool_partitions = dppl.delete_if do |dpp|
			! @partitions.select{ |p| p[:path] == dpp.path }.empty?
		end
	end

#	def settings
#		# do the settings page here
#	end

#	def advanced
#		# do the advanced settings page here
#	end
end