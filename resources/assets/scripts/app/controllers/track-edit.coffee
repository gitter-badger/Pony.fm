# Pony.fm - A community for pony fan music.
# Copyright (C) 2016 Peter Deltchev
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

window.pfm.preloaders['track-edit'] = [
    'tracks', '$state', 'playlists'
    (tracks, $state, playlists) ->
        $.when.all [tracks.fetch $state.params.id, playlists.refreshOwned(true)]
]

angular.module('ponyfm').controller "track-edit", [
    '$scope', 'tracks', '$state', 'playlists', 'auth', 'favourites', '$dialog'
    ($scope, tracks, $state, playlists, auth, favourites, $dialog) ->
        track = null

        tracks.fetch($state.params.id).done (trackResponse) ->
            $scope.track = trackResponse.track
            track = trackResponse.track

]
