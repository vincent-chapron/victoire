ngApp.controller("PageController",
    ["$scope", "$timeout", "widgetLocalStorageService", "widgetAPIService", "$sce",
        function($scope, $timeout, $widgetLocalStorageService, $widgetAPI, $sce) {
            $scope.init = function(viewCssHash) {
                $timeout(function() {
                    $scope.loadAsynchronousWidgets();
                });
                $scope.viewCssHash = viewCssHash;
            };

            $scope.feedAsynchronousWidget = function(widget) {
                $widgetScope = $(widget).scope();
                if ($widgetScope != undefined) {
                    $widgetScope.html = $sce.trustAsHtml($widgetLocalStorageService.fetchStorage($(widget).data('id')));
                    if ($widgetScope.html != undefined && $widgetScope.html != "") {
                        $(widget).removeClass('vic-widget-asynchronous').addClass('vic-widget-asynchronous-was');
                    }
                }
            };

            $scope.loadAsynchronousWidgets = function() {
                if (debug != undefined && debug == false) {
                    //Try fetching localstorage first
                    $('.vic-widget-asynchronous').each(function () {
                        $scope.feedAsynchronousWidget($(this));
                    });
                }

                widgetIds = [];
                $('.vic-widget-asynchronous').each(function() {
                    if (widgetIds.length < 100) {
                        widgetIds.push($(this).data('id'));
                    }
                });

                if (widgetIds.length < 10) {
                    for (key in widgetIds) {
                        //cal API to get html, widget after widget
                        widget = '#vic-widget-' + widgetIds[key] + '-container';
                        $widgetScope = $(widget).scope();
                        $widgetScope.widgetId = $(widget).data('id');
                        $widgetScope.fetchAsynchronousWidget();
                    }
                } else {
                    //too much widgets, let's fetch them in one shot
                    var promise = $widgetAPI.widgets(widgetIds);
                    promise.then(
                        function(payload) {
                            for (_widgetId in payload.data) {

                                $widgetLocalStorageService.store(_widgetId, payload.data[_widgetId]);
                                $scope.feedAsynchronousWidget($('#vic-widget-' + _widgetId + '-container'));
                            }
                            //Due to possible too high number of attribute and maximum size of a query
                            if (widgetIds.length == 100) {
                                $scope.loadAsynchronousWidgets();
                            }
                        },
                        function(errorPayload) {
                            console.error('/widgets API call has failed.');
                            console.error(errorPayload);
                        });
                }
            };
        }
    ]);
