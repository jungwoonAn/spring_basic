console.log('Reply Module...');

let replyService = (
    function(){
        // 댓글 등록
        function add(reply, callback, error){
            console.log('reply...');
            
            $.ajax({
                type: 'post',
                url: '/replies/new',
                data: JSON.stringify(reply),  // js객체 -> json
                contentType: 'application/json; charset=utf-8',
                success: function(result, status, xhr){
                    if(callback){
                        callback(result);
                    }
                },
                error: function(xhr, status, er){
                    if(error){
                        error(er);
                    }
                }
            }); 
        }

        // 댓글 목록
        function getList(param, callback, error){
            let bno = param.bno;
            let page = param.page || 1;

            $.ajax({
                type: 'get',
                url: '/replies/pages/' + bno + '/' + page,
                success: function(result, status, xhr){
                    if(callback){
                        // callback(result);  // 댓글 목록만 가져오는 경우
                        // 댓글 갯수와 목록을 가져오는 경우
                        callback(result.replyCnt, result.list);
                    }
                },
                error: function(xhr, status, er){
                    if(error){
                        error(er);
                    }
                }
            });

            // $.getJSON('/replies/pages/' + bno + '/' + page
            //     , function(data){
            //         if(callback){
            //             callback(data);
            //         }
            //     }).fail(function(xhr, status, err){
            //         if(error){
            //             error();
            //         }
            // });
        }

        // 댓글 삭제
        function remove(rno, replyer, callback, error){
            $.ajax({
                type: 'delete',
                url: '/replies/' + rno,
                data: JSON.stringify({rno: rno, replyer: replyer}),
                contentType: "application/json; charset=utf-8",
                success: function(deleteResult, status, xhr){
                    if(callback){
                        callback(deleteResult);
                    }
                },
                error: function(xhr, status, er){
                    if(error){
                        error(er);
                    }
                }
            });
        }

        // 댓글 수정
        function update(reply, callback, error){
            console.log('rno : ' + reply.rno);

            $.ajax({
                type: 'put',
                url: '/replies/' + reply.rno,
                data: JSON.stringify(reply),
                contentType: 'application/json; charset=utf-8',
                success: function(result, status, xhr){
                    if(callback){
                        callback(result);
                    }
                },
                error: function(xhr, status, er){
                    if(error){
                        error(er);
                    }
                }
            });
        }

        // 댓글 조회
        function get(rno, callback, error){
            $.ajax({
                type: 'get',
                url: '/replies/' + rno,
                success: function(result, status, xhr){
                    if(callback){
                        callback(result);
                    }
                },
                error: function(xhr, status, er){
                    if(error){
                        error(er);
                    }
                }
            });

            // $.get('/replies/' + rno, function(result){
            //     if(callback){
            //         callback(result);
            //     }
            // }).fail(function(xhr, status, err){
            //     if(error){
            //         error(er);
            //     }
            // });
        }

        // 댓글 시간 처리
        function displayTime(timeValue){
            let today = new Date();
            let gap = today.getTime() - timeValue;

            let dateObj = new Date(timeValue);
            let str = '';

            if(gap < (1000*60*60*24)){  // 24시간 이내
                let hh = dateObj.getHours();
                let mi = dateObj.getMinutes();
                let ss = dateObj.getSeconds();

                return [(hh > 9 ? '' : '0') + hh, ':',
                    (mi > 9 ? '' : '0') + mi, ':',
                    (ss > 9 ? '' : '0') + ss
                ].join('');
            }else {
                let yy = dateObj.getFullYear();
                let mm = dateObj.getMonth() + 1;  // getMonth() is zero-based
                let dd = dateObj.getDate();

                return[yy, '/', (mm > 9 ? '' : '0') + mm, '/',
                    (dd > 9 ? '' : '0') + dd
                ].join('');
            }
        }

        return {
            add: add,
            getList: getList,
            remove: remove,
            update: update,
            get: get,
            displayTime: displayTime
        };
    }
)();