class Page
  include Mongoid::Document
  field :name, type: String
  field :_id, type: String, default: ->{ SecureRandom.base58 }
#  field :parts, type: Array, default: []
  field :parts_order, type: Array, default: []

  embeds_many :parts, class_name: 'PagePart'
  validates_presence_of :name

	def get_part part_id
		self.parts.find(part_id)
	end
	def insert_part_after block_type, after_part, config={}, content={}
#parts.clear
		self.parts_order ||= []
		part = self.parts.create! block_type: block_type, config: config, content: content
		ind = parts_order.find_index(after_part) || -1
		self.parts_order.insert ind+1, part._id
		#self.parts_order << part
		#self.parts_order << 123
		self.save
		part
	end
	def remove_part part_id
		self.parts.find(part_id).destroy!
		#self.parts_order - [part_id]
		self.parts_order.delete(part_id)
		self.save
		puts parts.to_a
	end
	def save_part_content part_id, content
		#self.parts.find(part_id).content = content
		part = self.parts.find(part_id)
		part.content = content
		part.save
	end
	def save_part_config part_id, config
		#self.parts.find(part_id).content = content
		part = self.parts.find(part_id)
		part.config = config
		part.save
puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
puts config.class
puts config
puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	end
	def get_parts
		rez = []
		p parts_order
		p parts
		(parts_order || []).each do |p_id|
			p = parts.find(p_id)
			rez << p if p
		end
		rez
	end

end

#class PageBlock
class PagePart
  include Mongoid::Document

#  field :_id, type: String, default: ->{ SecureRandom.base58 }
  field :_id, type: String, default: ->{ SecureRandom.base34(8) }
  field :block_type, type: String
  field :config, type: Hash, default: {}
  field :content, type: Hash, default: {}

  embedded_in :page
end

