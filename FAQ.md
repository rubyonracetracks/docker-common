# Docker Debian - FAQ

## How do I build a Docker image on my local machine?
* You MUST have Docker installed.
* From the root directory of the Docker image build repository, enter the command "bash build-SUITE.sh" to start the build process.  (Replace "SUITE" with the suite code name.  For example, enter the command "bash build-trixie.sh" to start the build process for a Debian Trixie image.)  The logging output file is in the log directory.
* NOTE: This manual process is used for experimental purposes and is NOT used to push Docker images.

## How do you build and push Docker images automatically?
* The process of building and pushing the Docker image is handled by GitHub Workflows.  The configuration files are within the .github directory.
* Note that the process of building the Docker image is a test.  The build process is set up to abort immediately in the event of an error.  This prevents bad Docker images from being pushed to the repository.
* The new image created in the build process is uploaded to the GitHub Container Registry ONLY when the build script is executed in the main branch.  Docker images more than a week old are removed.
* GitLab's cron scheduling feature is used to automatically build Docker images on a regular basis.

## Why do you prefer the GitHub Container Registry over Docker Hub?
The GitHub Container registry has much more generous terms than Docker Hub.  Docker Hub has too many restrictions.

## Why do you prefer RVM over other Ruby version manager software?
* I was unable to make patch upgrades to the Ruby version in my Rails apps under rbenv.  When I tried to upgrade Rails apps from Ruby 2.6.0 to 2.6.3 (by updating the .ruby-version file and Gemfile), I was getting the error message "Your Ruby version is 2.6.0, but your Gemfile specified 2.6.3."  Although I had both versions of Ruby installed in the Docker image, entered the commands "rbenv local 2.6.3" and "rbenv global 2.6.3", and followed other suggestions I had seen online, I still couldn't resolve this issue.  So I tried a similar setup with RVM instead of rbenv, and I was able to upgrade the app without any problems.
* I tried asdf.  All "rails" commands had to begin with "bundle exec", and I didn't feel like changing the Bash scripts in all of my Rails apps to reflect this.
* I tried chruby.  It's more difficult to automate the process of installing chruby than it is to automate the process of installing RVM.  Given that its underlying mechanisms are much simpler than those of rbenv and RVM (which means fewer things that can break), I understand why chruby would appeal to those who rely on their host systems as their development environments.  If RVM didn't exist, I'd probably use chruby.
