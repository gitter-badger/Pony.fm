# Pony.fm - A community for pony fan music.
# Copyright (C) 2016 Josef Citrine
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

window.pfm.preloaders['admin-tracks'] = [
    'tracks', '$state'
    (tracks, $state) ->
        tracks.loadFilters().then(->
            tracks.mainQuery.fromFilterString($state.params.filter)
            tracks.mainQuery.setPage $state.params.page || 1
            tracks.mainQuery.setAdmin true

            tracks.mainQuery.fetch()
        )
]

module.exports = angular.module('ponyfm').controller "admin-tracks", [
    '$scope', 'tracks', '$state',
    ($scope, tracks, $state) ->
        tracks.mainQuery.fetch().done (searchResults) ->
            $scope.tracks = searchResults.tracks

            $scope.currentPage = parseInt(searchResults.current_page)
            $scope.totalPages = parseInt(searchResults.total_pages)
            delete $scope.nextPage
            delete $scope.prevPage

            $scope.nextPage = $scope.currentPage + 1 if $scope.currentPage < $scope.totalPages
            $scope.prevPage = $scope.currentPage - 1 if $scope.currentPage > 1
            $scope.allPages = [1..$scope.totalPages]

            # TODO: turn this into a directive
            # The actual first page will always be in the paginator.
            $scope.pages = [1]

            # This logic determines how many pages to add prior to the current page, if any.
            firstPage = Math.max(2, $scope.currentPage-3)
            $scope.pages = $scope.pages.concat [firstPage..$scope.currentPage] unless $scope.currentPage == 1

            pagesLeftToAdd = 8-$scope.pages.length

            lastPage = Math.min($scope.totalPages - 1, $scope.currentPage+1+pagesLeftToAdd)
            $scope.pages = $scope.pages.concat([$scope.currentPage+1..lastPage]) unless $scope.currentPage >= lastPage

            # The actual last page will always be in the paginator.
            $scope.pages.push($scope.totalPages) unless $scope.totalPages in $scope.pages

        $scope.pageSelectorShown = false

        $scope.gotoPage = (page) ->
            $state.transitionTo 'content.tracks.list', {filter: $state.params.filter, page: page}

        $scope.showPageSelector = () ->
            $scope.pageSelectorShown = true
            focus('#pagination-jump-destination')

        $scope.hidePageSelector = () ->
            $scope.pageSelectorShown = false


        $scope.jumpToPage = (inputPageNumber) ->
            $scope.gotoPage(inputPageNumber)

]
