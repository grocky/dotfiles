function success_log() {
  echo "✅ ${1}"
}

function error_log() {
  echo "❌ ${1}"
}

function log_command_status() {
  if [ ${1} -ne 0 ]; then 
    error_log "${2}" 
  else
    success_log "${2}"
  fi
}

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" " 
log_command_status $? "Disable the sound effects on boot"

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
log_command_status $? "Disable automatic capitalization"

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
log_command_status $? "Disable smart dashes."

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
log_command_status $? "Disable automatic period substitution."

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
log_command_status $? "Disable smart quotes."

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
log_command_status $? "Disable auto-correct."

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
log_command_status $? "Use scroll gesture with Ctrl modifier key to zoom."

# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true
log_command_status $? "Follow the keyboard focus while zoomed in."

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
log_command_status $? "Set fast keyboard repeat rate. KeyRepeat = 1"
defaults write NSGlobalDomain InitialKeyRepeat -int 10
log_command_status $? "Set fast keyboard repeat rate. InitialKeyRepeat = 10"

# Store screenshots on the Desktop
[ ! -d "${HOME}/Desktop/screenshots" ] && mkdir -p "${HOME}/Desktop/screenshots" && success_log "Create screenshots directory."
defaults write com.apple.screencapture location -string "${HOME}/Desktop/screenshots"
log_command_status $? "Set screenshos directory to ${HOME}/Desktop/screenshots."

defaults write com.apple.screencapture type -string "png"
log_command_status $? "Set screenshos filetype to png."

defaults write com.apple.screencapture disable-shadow -bool true
log_command_status $? "Disable screenshot shadow."

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true
log_command_status $? "Show hidden files by default."

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
log_command_status $? "Show all filename extensions."

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
log_command_status $? "Disable warning when changing file extensions."

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
log_command_status $? "Prevent Time Machine from prompting to use new hard drives as backup volume."

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
log_command_status $? "Show the main window when launching Activity Monitor."

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5
log_command_status $? "Visualize CPU usage in the Activity Monitor dock icon."

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0
log_command_status $? "Show all processes in Activity Monitor."

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
log_command_status $? "Sort Activity Monitor results by CPU usage."

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
log_command_status $? "Disable Photos from opening automatically when devices are plugged in."

echo "Done. Note that some of these changes require a logout/restart to take effect."
