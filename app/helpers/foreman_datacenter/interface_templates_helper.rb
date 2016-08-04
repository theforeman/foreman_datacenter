module ForemanDatacenter
  module InterfaceTemplatesHelper
    def interface_template_form_factors
      InterfaceTemplate::FORM_FACTORS.zip(InterfaceTemplate::FORM_FACTORS)
    end
  end
end
