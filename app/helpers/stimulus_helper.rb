module StimulusHelper
  def stim_textarea
    {controller: "textarea",
     action: "change->textarea#resize input->textarea#resize",
     target: "textarea.textarea"}
  end
end
