set :branch, 'master'

server '54.250.154.45', user: 'ec2-user', roles: %w[web app db]

set :ssh_options, {
    keys: [File.expand_path('/Users/angelica/.ssh/chalkboard.pem')],
    forward_agent: true,
    fetch(:user)
}