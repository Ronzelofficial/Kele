module Roadmap
  def get_roadmap(id)
    response = self.class.get("/roadmaps/#{id}", headers: { "authorization" => @auth_token })
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(id)
    response = self.class.get("/checkpoints/#{id}", headers: { "authorization" => @auth_token })
    @checkpoint = JSON.parse(response.body)
  end
end
