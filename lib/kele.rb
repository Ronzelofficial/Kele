require 'httparty'
require 'json'
require './lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @userinfo = {email: email, password: password}
    response = self.class.post('/sessions', body: @userinfo)
    @auth_token = response["auth_token"]
    raise "Invalid login information" if @auth_token.nil?
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page_num = nil)
    if page_num == nil
      response = self.class.get("/message_threads/", headers: { "authorization" => @auth_token })
    else
      response = self.class.get("/message_threads?page=#{page_num}", headers: { "authorization" => @auth_token })
    end
    @messages = JSON.parse(response.body)
  end

   def create_message(sender, recipient_id, subject, message)
    response = self.class.post("/messages", headers: { "authorization" => @auth_token },
      body: {
        "sender": sender,
        "recipient_id": recipient_id,
        "subject": subject,
        "stripped-text": message
      })
   end

   def create_submission(barnch, commit_link, check_id, comment, enroll_id)
    response = self.class.post("/checkpoint_submissions", headers: { "authorization" => @auth_token },
      body: {
        "assignment_branch": branch,
        "assignment_commit_link": commit_link,
        "checkpoint_id": check_id,
        "comment": comment,
        "enrollment_id": enroll_id
      })
      @checkpoint = JSON.parse(response.body)
    end
end
