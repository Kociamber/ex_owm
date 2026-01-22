# Load test support files
Code.require_file("test/support/fixtures.ex")
Code.require_file("test/support/test_helpers.ex")

ExUnit.start(exclude: [:api_based_test])
