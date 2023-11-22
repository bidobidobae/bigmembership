module DispatchEventHelper
  def dispatch_event(member)
    turbo_stream_action_tag :dispatch_event, member: member
  end
end

Turbo::Streams::TagBuilder.prepend(DispatchEventHelper)
