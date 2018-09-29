set :branch, 'master'
set :rails_env, 'production'

server '54.250.154.45', user: 'ec2-user', roles: %w[web app db]

set :ssh_options, {
    keys: [File.expand_path('~/.ssh/id_rsa')],
    forward_agent: true,
    auth_methods: %w(publickey)
    }