
About
=======

This project provides a template for developing Puppet deployments.


The Vagrantfile has the following features

  - A `HOSTS` array to provision multiple virtual machines.
  - An array of `REQUIRED_PLUGINS`. A fatal error is thrown if a
  required plugin is not installed.
  - An attempt to restore landrush iptables entries after any firewalld
  changes made during puppet provisioning.
  - Invokes puppet librarian plugin, unless a `nolibrarian` file is
  present at the same level as `Vagrantfile`.
  
The `puppet` directory layout is modeled after EBRC's production Puppet
structure. This template uses Puppet librarian (whereas production does
not) so the modules directory is empty. Local profiles and other
manifests are under the `src` directory and will be installed into the
`modules` directory by librarian. Librarian deletes the contents of
`modules` on each Vagrant provision so do not keep development changes
in the `modules` directory. The librarian run will be skipped if there
is a `nolibrarian` file at the same level as `Vagrantfile`.

Usage
=======

Clone the template project to a new name and remove the git tracking history.

    NEWPROJECT=vagrant-newdev
    git clone --depth 1 --branch master https://github.com/EuPathDB/vagrant-puppet_template.git vagrant-$NEWPROJECT
    cd vagrant-$NEWPROJECT
    rm -rf .git

Add, edit `Vagrantfile` and puppet manifests as needed. Probably you
will want to track changes in a SCM.

    git init
    git add .
    git commit -m 'init`

Manual Puppet Apply
=======

sudo /opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/main.pp
