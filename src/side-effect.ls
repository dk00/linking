import
  \./class-factory : class-factory
  \./flat-diff : flat-diff

function render-empty => ''
function has-changes next => flat-diff @props, next

function side-effect Component
  create-class = class-factory Component
  (handle-change) ~>
    instances = []
    emit-change = !~> handle-change instances.map (.props)

    create-class do
      component-will-mount: !->
        instances.push @
        emit-change!
      should-component-update: has-changes
      component-did-update: emit-change
      component-will-unmount: !->
        instances.splice (instances.index-of @), 1
        emit-change!
      render: render-empty

export default: side-effect
