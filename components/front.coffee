if Meteor.isClient
    Template.front.onCreated ->
        # @autorun => Meteor.subscribe 'role_models', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'vacuum'
        @autorun => Meteor.subscribe 'reservations_by_slug', 'rugdoctor'
        # @autorun => Meteor.subscribe 'model_docs', 'marketplace'
        # @autorun => Meteor.subscribe 'model_docs', 'gr_post'

    Template.front.helpers
        vacuum_doc: ->
            Docs.findOne
                model:'shop_item'
                slug:'rugdoctor'
        vacuum_reservations: ->
            Docs.find
                model:'reservation'
                slug:'rugdoctor'
        editing_reservation: -> Session.get 'editing_reservation_id'


    Template.front.events
        'click .new_reservation': ->
            new_reservation = Docs.insert
                model:'reservation'
                product_slug:'rugdoctor'
            Session.set 'editing_reservation_id', new_reservation









    # Template.front.onCreated ->
    #     # @autorun => Meteor.subscribe 'role_models', Router.current().params.doc_id
    #     @autorun => Meteor.subscribe 'role_models', Router.current().params.doc_id
    #     # @autorun => Meteor.subscribe 'model_docs', 'marketplace'
    #     # @autorun => Meteor.subscribe 'model_docs', 'gr_post'
    #     # @autorun => Meteor.subscribe 'model_docs', 'gr_post'
    #     # @autorun => Meteor.subscribe 'model_fields_from_child_id', Router.current().params.doc_id
    #
    # Template.front.events
    #     'click .set_model': ->
    #         Session.set 'loading', true
    #         Meteor.call 'set_facets', @slug, ->
    #             Session.set 'loading', false
    #
    # Template.front.helpers
    #     role_models: ->
    #         # console.log Meteor.user().roles
    #         Docs.find {
    #             model:'model'
    #             view_roles:$in:Meteor.user().roles
    #         }, sort:title:1
    #
    #     marketplace_items: ->
    #         # console.log Meteor.user().roles
    #         Docs.find {
    #             model:'marketplace'
    #         }, sort:_timestamp:1
    #
    #     posts: ->
    #         # console.log Meteor.user().roles
    #         Docs.find {
    #             model:'gr_post'
    #         }, sort:_timestamp:1



    Template.water_status.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'water_status'
    Template.water_status.helpers
        on: ->
            water_feature_status_doc =
                Docs.findOne
                    model:'water_status'
                    slug:@slug
            water_feature_status_doc.on
    Template.water_status.events
        'click .toggle_status': ->
            console.log @
            status_doc =
                Docs.findOne
                    model:'water_status'
                    slug:@slug
            if status_doc
                Docs.update status_doc._id,
                    $set:on:!status_doc.on
            else
                Docs.insert
                    model:'water_status'
                    slug:@slug
                    on:true

    Template.model_scroller.onCreated ->
        @skip = new ReactiveVar 0
        @autorun => Meteor.subscribe 'model_docs_with_skip', @data.model, @skip.get()
    Template.model_scroller.helpers
        user_results: -> Template.instance().user_results.get()
        current_doc: ->
            # console.log @model
            Docs.findOne {
                model:@model
            }, skip: Template.instance().skip.get()
            # }
        model_doc_template: ->
            # console.log "#{@model}_doc_view"
            "#{@model}_doc_view"

        can_go_left: ->
            Template.instance().skip.get() > 0
        can_go_right: ->
            count = Docs.find(model:@model).count()
            # console.log count
            Template.instance().skip.get() < count-1


    Template.model_scroller.events
        'click .go_to_model': ->
            # console.log @
            Session.set 'loading', true
            Meteor.call 'set_facets', @model, ->
                Session.set 'loading', false
            # Router.go "/m/#{@model}"
        'click .go_left': ->
            current_skip = Template.instance().skip.get()
            unless current_skip is 0
                Template.instance().skip.set(current_skip-1)
        'click .go_right': ->
            current_skip = Template.instance().skip.get()
            Template.instance().skip.set(current_skip+1)





if Meteor.isServer
    Meteor.publish 'model_docs_with_skip', (model, skip)->
        # console.log model
        # console.log skip
        Docs.find {
            model:model
        }


    Meteor.publish 'vacuum', ()->
        # console.log model
        # console.log skip
        Docs.find {
            model:'shop_item'
            slug:'rugdoctor'
        }


    Meteor.publish 'reservations_by_slug', (slug)->
        # console.log model
        # console.log skip
        Docs.find {
            model:'reservation'
            slug:slug
        }