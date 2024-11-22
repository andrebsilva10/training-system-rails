module CapybaraCustomAssertions
  def assert_alert(expected_text)
    selector = first(:css, 'div[role="alert"]')

    within(selector) do
      assert_text expected_text
    end
  end
end
