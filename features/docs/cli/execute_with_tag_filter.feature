Feature: Tag logic
  In order to conveniently run subsets of features
  As a Cuker
  I want to select features using logical AND/OR of tags

  Background:
    Given a file named "features/test.feature" with:
      """
      @feature
      Feature: Sample

        @one @three
        Scenario: Example
          Given passing

        @one
        Scenario: Another Example
          Given passing

        @three
        Scenario: Yet another Example
          Given passing

        @ignore
        Scenario: And yet another Example
      """

  Scenario: ANDing tags
    When I run `cucumber -q -t @one -t @three features/test.feature`
    Then it should pass with:
      """
      @feature
      Feature: Sample

        @one @three
        Scenario: Example
          Given passing

      1 scenario (1 undefined)
      1 step (1 undefined)

      """

  Scenario: ORing tags
    When I run `cucumber -q -t @one,@three features/test.feature`
    Then it should pass with:
      """
      @feature
      Feature: Sample

        @one @three
        Scenario: Example
          Given passing

        @one
        Scenario: Another Example
          Given passing

        @three
        Scenario: Yet another Example
          Given passing

      3 scenarios (3 undefined)
      3 steps (3 undefined)

      """

  Scenario: Negative tags
    When I run `cucumber -q -t ~@three features/test.feature`
    Then it should pass with:
      """
      @feature
      Feature: Sample

        @one
        Scenario: Another Example
          Given passing

        @ignore
        Scenario: And yet another Example

      2 scenarios (1 undefined, 1 passed)
      1 step (1 undefined)
      """

  Scenario: Limiting with tags which do not exist in the features
    Originally added to check [Lighthouse bug #464](https://rspec.lighthouseapp.com/projects/16211/tickets/464).

    When I run `cucumber -q -t @i_dont_exist features/test.feature`
    Then it should pass
