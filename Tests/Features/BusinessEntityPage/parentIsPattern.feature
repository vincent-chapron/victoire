@mink:selenium2 @alice(Page) @reset-schema
Feature: Mercenary is not a BusinessEntity itself but extends Character which is one

    Background:
        Given I am logged in as "anakin@victoire.io"
        And I resize the window to 1024x720

    Scenario: I can view the mercenary show view
        Given the following Mercenaries:
            | name       | midiChlorians | slug       |
            | Boba fet   | 1500          | boba-fet   |

        Given I open the hamburger menu
            Then I should see "Représentation métier"
            When I follow "Représentation métier"
            Then I should see "Ajouter une représentation métier"
            When I follow the tab "Character"
            And I should see "Ajouter une représentation métier"
            And I follow "Ajouter une représentation métier"
            Then I should see "Créer une représentation métier"
            When I fill in "Nom" with "Fiche Personnage - {{item.name}}"
            And I fill in "URL" with "fiche-personnage-{{item.slug}}"
            And I follow "Créer"
            And I wait 10 seconds
            And I should be on "/fr/victoire-dcms/business-template/show/5"
            Then I switch to "layout" mode
            When I select "Text" from the "1" select of "content" slot
            Then I should see "Créer"
            When I follow "Personnages"
            And I follow "Objet courant"
            And I select "name" from "character_businessEntity_victoire_widget_form_text[fields][content]"
            And I submit the widget
            Then I should see "Victoire !"
            Then I should see "-> name"
        Given I am on "/fr/fiche-personnage-boba-fet"
            Then I should see "Boba fet"

        # TEST the virtual BEP is available in LinkExtension
        Given I am on "/"
            When I select "Bouton" from the "1" select of "content" slot
            Then I should see "Créer"
            When I select "Page" from "_static_victoire_widget_form_button[link][linkType]"
            And I wait 1 second
            When I select "Fiche Personnage - Boba fet" from "_static_victoire_widget_form_button[link][viewReference]"
            And I fill in "_static_victoire_widget_form_button[title]" with "Fiche de Boba fet"
            And I submit the widget
            Then I should see "Victoire"
            Given I reload the page
            Then I should see "Fiche de Boba fet"
            When I follow "Fiche de Boba fet"
            Then I should be on "/fr/fiche-personnage-boba-fet"

        # TEST a concrete BEP is available in LinkExtension
        #When I select "Text" from the "1" select of "content" slot
        #Then I should see "Créer"
        #And I fill in "_static_victoire_widget_form_text[content]" with "My name is"
        #And I submit the widget
        #And I wait 3 seconds
        #Given I am on "/"
        #Then I should see "Fiche de Boba fet"
        #When I follow "Fiche de Boba fet"
        #Then I should be on "/fr/fiche-personnage-boba-fet"
