<%--
Copyright (c) 2011, salesforce.com, inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided
that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the
following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of salesforce.com, inc. nor the names of its contributors may be used to endorse or
promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
--%>

<%@ page import="canvas.SignedRequest" %>
<%@ page import="java.util.Map" %>
<%
    // Pull the signed request out of the request body and verify/decode it.
    Map<String, String[]> parameters = request.getParameterMap();
    String[] signedRequest = parameters.get("signed_request");
    if (signedRequest == null) {%>
        This App must be invoked via a signed request!<%
        return;
    }
    String yourConsumerSecret=System.getenv("CANVAS_CONSUMER_SECRET");
    String signedRequestJson = SignedRequest.verifyAndDecodeAsJson(signedRequest[0], yourConsumerSecret);
    
%>
<!DOCTYPE html>
<html>
    <head>
        <!-- Sysco Same Day, Instant Order, Sysco Now -->
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>

        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="css/bootstrap.min.css" />
        <link rel="stylesheet" href="css/bootstrap-glyphicons.css"/>
        <link rel="stylesheet" media="screen" type="text/css" href="css/input-style.css" />
        <script src="scripts/jquery.js"></script>

        <!-- Latest compiled and minified JavaScript -->
        <script src="scripts/underscore-min.js"></script>
        <script src="scripts/bootstrap.min.js"></script>

        <script type="text/javascript" src="sdk/js/canvas-all.js"></script>
        <script type="text/javascript" src="scripts/json2.js"></script>
        <script type="text/javascript" src="scripts/chatter-talk.js"></script>

        <script>
        </script>

    </head>
    <body style="font-size: 16px">
        <img id="header-logo" alt="" class="pull-left" src="" style="max-height: 30px; padding-bottom: 2px; margin-left: -8px; margin-top: -10px;">
        <!-- 
        <img alt="" class="pull-right" src="images/Sysco_Logo.png" height="40px" style="padding-bottom: 5px; margin-top: -10px; margin-left: -10px;">
        -->
        <div class="container" style="width: 308px; margin-left: -25px; margin-right: -25px;">
            <div class="col-12">
                <div class="well well-small">
                    <div id="headers" class="row">
                        <div>
                            <h4 id="fullname"><strong>Order Now</strong></h4>
                            <br/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
							<address>
  								<div class="row">
                                	<span id="acctName"><strong>3rd Base Breakfast</strong></span>
									<a data-toggle="modal" href="#myModal" class="btn btn-small btn-primary pull-right">
										<span class="glyphicon glyphicon-search"></span>
									</a>
  								</div>
                                <div class="row">
                                	<span id="acctStreet">2274 Lombard Street</span><br>
                                	<span id="acctCityStateZip">San Francisco, CA 94123</span><br>
                                	<abbr title="Phone">P:</abbr>
                                	<span id="acctPhone">(650) 743-8611</span>
								</div>
                            </address>
                        </div>
                    </div>
                </div>
                <div class="well well-small">
                    <div class="row">
                        <label for="prodLookup" class="col-12">Product Lookup</label>
                    </div>
                    <div class="row">
                        <div class="col-9">
                            <input id="prodLookup" class="form-control" type="text" placeholder="Product name" />
                        </div>
                        <div class="col-2">
                            <button data-toggle="modal" data-target="#lookupModal" style="margin-right: 30px" type="button" class="btn btn-default">
                                <span class="glyphicon glyphicon-search"></span>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-heading" id="ordertitle">Order Info (empty)</div>
                    <ul class="list-group" style="display: none" id="prodList">
                    </ul>
                    <div class="panel-footing" style="display: none" id="footer">
                        <button type="button" class="btn btn-default" onclick="submitOrder();">Submit Order</button>
                    </div>
                </div>

            </div>
        </div>


        <!-- Modal -->
        <div class="modal fade" id="myModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        Select Other Account
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    </div>
                    <div class="modal-body">
                        <ul class="list-group" id="nearbyList">
                            <!-- <li class="list-group-item" onclick="changeAccount('Pats Deli');">
                                <span class="badge">0.9</span>
                                Pats Deli
                            </li>-->
                        </ul>
                    </div>
                    <div class="modal-footer">
                        <a href="#myModal" data-dismiss="modal" class="btn btn-primary">Close</a>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->  
    
        <!-- Modal -->
        <div class="modal fade" id="lookupModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        Find Product
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    </div>
                    <div class="modal-body">
						<div class="accordion" id="accordion2">
						  <div class="accordion-group">
						    <div class="accordion-heading">
						      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
						        Bacon Bits (3 lb)
                                <span class="pull-right glyphicon glyphicon-ok"></span>
						      </a>
						    </div>
						    <div id="collapseOne" class="accordion-body collapse">
						      <div class="accordion-inner">
								<select id="prodQuant_bits" onchange="setProductQuantity('Bacon Bits', this.value, 'collapseOne')">
                            		<option value="0">none</option>
                            		<option value="1">1 unit</option>
                            		<option value="3">3 units</option>
                            		<option value="5">5 units</option>
                        		</select>
                        		</div>
						    </div>
						  </div>
						  <div class="accordion-group">
						    <div class="accordion-heading">
						      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo">
								<span class="pull-right glyphicon glyphicon-ok"></span>
                                Thin Bacon (20 lb)						      
                              </a>
						    </div>
						    <div id="collapseTwo" class="accordion-body collapse">
						      <div class="accordion-inner">
								<select id="prodQuant_thin" onchange="setProductQuantity('Thin Bacon', this.value, 'collapseTwo')">
                            		<option value="0">none</option>
                            		<option value="1">1 unit</option>
                            		<option value="3">3 units</option>
                            		<option value="5">5 units</option>
                        		</select>
						      </div>
						    </div>
						  </div>
						  <div class="accordion-group">
						    <div class="accordion-heading">
						      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseThree">
                                <span class="pull-right glyphicon glyphicon-ok"></span>
                                Maple Bacon (10 lb)
						      </a>
						    </div>
						    <div id="collapseThree" class="accordion-body collapse">
						      <div class="accordion-inner">
								<select id="prodQuant_maple" onchange="setProductQuantity('Maple Bacon', this.value, 'collapseThree')")>
                            		<option value="0">none</option>
                            		<option value="1">1 unit</option>
                            		<option value="3">3 units</option>
                            		<option value="5">5 units</option>
                        		</select>
						      </div>
						    </div>
						  </div>
						  <div class="accordion-group">
						    <div class="accordion-heading">
						      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" >
                                <span class="pull-right glyphicon glyphicon-ban-circle"></span>
                                Smoked Bacon (10 lb)
						      </a>
						    </div>
						  </div>
						</div>


                        <!--  <ul class="list-group">
                            <li class="list-group-item" onclick="setQuantity('Bacon Bits');">
                                Bacon Bits (3 lb)
                                <span class="pull-right glyphicon glyphicon-ok"></span>
                            </li>
                            <li class="list-group-item" onclick="setQuantity('Maple Bacon');">
                                <span class="pull-right glyphicon glyphicon-ban-circle"></span>
                                Maple Bacon (10 lb)
                            </li>
                            <li class="list-group-item" onclick="setQuantity('Smoked Bacon');">
                                <span class="pull-right glyphicon glyphicon-ban-circle"></span>
                                Smoked Bacon (10 lb)
                            </li>
                            <li class="list-group-item" onclick="setQuantity('Thin Bacon');">
                                <span class="pull-right glyphicon glyphicon-ok"></span>
                                Thin Bacon (20 lb)
                            </li>
                        </ul>-->
                    </div>
                    <div class="modal-footer">
                        <a href="#lookupModal" data-dismiss="modal" class="btn btn-primary">Close</a>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->  
		
        <div class="modal fade" id="quantityModal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header" id="quantHeader">
                        Find Product
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    </div>
                    <div class="modal-body">
                        <select id="prodQuant">
                            <option>1 unit</option>
                            <option>3 units</option>
                            <option>5 units</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" onclick="setProductQuantity()">Save</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->  

	    <!-- Modal -->
	    <div class="modal fade" id="modalConfirm">
    	    <div class="modal-dialog">
        	    <div class="modal-content">
            	    <div class="modal-header">
                	    Delivery Scheduled!
                    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                </div>
    	            <div class="modal-body">
        	            <div class="row">
            	            <strong>Your Driver</strong><br/>
	                       <div>
    	                        <span id="mydriver"></span><br/>
            	                Phone: 650-8976
                	        </div>
                    	</div>
	                    <br/>
    	                <div class="row">
        	                <div class="well well-small">
            	                <h4>Order Summary</h4><br/>
                	            <strong>Items</strong>
                    	        <ul class="list-group" style="font-size: 12px" id="confirmProdList">
                            	</ul>
	                            <strong>Delivery Info</strong><br/>
    	                        <ul class="list-group">
        	                        <li class="list-group-item" style="font-size: 14px">
            	                        Scheduled:<br/>
            	                        <span style="font-size: 12px" id="scheduledTime"></span>
                	                </li>
                                	<li class="list-group-item" style="font-size: 14px">
	                                    Account:<br/>
	                                    <span style="font-size: 12px" id="acctConfirm"></span>
    	                            </li>
        	                    </ul>
            	            </div>
                	        <a href="#myModal" data-dismiss="modal" class="pull-right btn btn-primary">Close</a>
                    	</div>
                	</div>
	            </div><!-- /.modal-content -->
    	    </div><!-- /.modal-dialog -->
    	</div><!-- /.modal -->  
	
        <script>
        if (self === top) {
            // Not in Iframe
            alert("This canvas app must be included within an iframe");
        }

        var sr, account, lastDelivery, activeDelivery, driverId;
        var deliveryUrl, queryUrl, quickActionUrl;
        var deliveries = [];
		var nearbyDeliveries = [];
		var nsPrefix = "";
		var logo;
		
        publishToRecordFeed = function(sr, options, callback) {
        	var url = sr.context.links.chatterFeedsUrl + "/record/" + options.recordId + "/feed-items";
        	var body = {body : {messageSegments : [{type: "Text", text: options.message}]}};
        	
            Sfdc.canvas.client.ajax(url,
                    {client : sr.client,
                     method: 'POST',
                     contentType: "application/json",
                     data: JSON.stringify(body),
                     success : function(data) {
                         callback(data);
                     }
                });
        };

        
        
        Sfdc.canvas(function() {
            sr = JSON.parse('<%=signedRequestJson%>');
            if (sr.context.organization.namespacePrefix == "drd") {
            	nsPrefix = "drd__";
            }
            $("#header-logo").attr("src", sr.client.instanceUrl + sr.context.environment.parameters.logo);
            
            console.log(JSON.stringify(sr, null, 4));
            deliveryUrl =sr.context.links.restUrl + "sobjects/" + nsPrefix + "Delivery__c";
            queryUrl = sr.context.links.restUrl + "query?q=";
            quickActionUrl = sr.context.links.restUrl + "sobjects/";
            lastDelivery = sr.context.environment.parameters.lastDelivery;
            driver = sr.context.environment.parameters.driver;
            $("#mydriver").html(driver.Name);
            activeDelivery = lastDelivery;
            account = lastDelivery[nsPrefix + "Account__r"];
            deliveries.push(lastDelivery);
            nearbyDeliveries = sr.context.environment.parameters.nearByDeliveries;
            var nbdMap = {};
            var nbDel = [];
            _.each(nearbyDeliveries, function(del) {
            	if (typeof nbdMap[del[nsPrefix + "Account__r"].Name] === 'undefined') {
            		nbdMap[del[nsPrefix + "Account__r"].Name] = del;
   	        		nbDel.push(del);
            	}
            });
            
            nearbyDeliveries = nbDel;
      

            $("#acctName").html(account.Name);
            $("#acctStreet").html(activeDelivery[nsPrefix + "Street__c"]);
            $("#acctCityStateZip").html(activeDelivery[nsPrefix + 'City__c'] + ", " + activeDelivery[nsPrefix + "State__c"] + " " + activeDelivery[nsPrefix + "Postal_Code__c"]);
            $("#acctPhone").html(activeDelivery[nsPrefix + "Phone__c"]);
            
           	_.each(nearbyDeliveries, function(del) {
           		var li = document.createElement("li");
	            	li.className = "list-group-item";
       	    	$(li).bind("click", function() {
           			changeAccount(del[nsPrefix + "Account__r"].Name);
           		});
            	$(li).html(del[nsPrefix + "Account__r"].Name);
   	        	var span = document.createElement("span");
       	    	span.className = "badge";
           		$(span).html("0.1");
           		//$(li).append(span);
           	
            	$("#nearbyList").append(li);
   	        });    

           	window.setTimeout(changeAccount, 200);
        }); 
        
        var formatDate = function(date) {
        	var d = new Date();
        	var offset = d.getTimezoneOffset() / 60;
        	if (offset < 10) offset = "0" + offset;
        	var formatted = date.getFullYear() + "-" + 
            ("0" + (date.getMonth() + 1)).slice(-2) + "-" + 
            ("0" + date.getDate()).slice(-2) + "T" + date.getHours() + ":" + 
            date.getMinutes() + ":" + date.getSeconds() + "-" + offset + "00"; 
            return formatted;
        }
        
        var addMinutes = function(date, minutes) {
            return new Date(date.getTime() + minutes*60000);
        }
        
        var getDelivery = function(deliveryId) {
        	var philCalvinId = "005R0000000HfWf";

			var quickAction = {};
			quickAction.parentId = activeDelivery[nsPrefix + "Account__c"];
			quickAction.record = {};
					
			quickAction.record.OwnerId = driver[0].Id;
			quickAction.record[nsPrefix + "Scheduled_Window__c"] = "55";

			var d = addMinutes(new Date(), 35);
			quickAction.record[nsPrefix + "Scheduled_Time__c"] = formatDate(d);
			quickAction.record[nsPrefix + "Phone__c"] = activeDelivery[nsPrefix + "Phone__c"];
			console.log(JSON.stringify(activeDelivery, null, 4));
			//quickAction.record.Location__Latitude__s = activeDelivery.Location__Latitude__s;
			//quickAction.record.Location__Longitude__s = activeDelivery.Location__Longitude__s;
			d.setSeconds(0);
			$("#scheduledTime").html(d.toLocaleTimeString());
			$("#acctConfirm").html(activeDelivery[nsPrefix + "Account__c"].Name);
			createDelivery(quickAction, quickActionUrl + "Account/quickActions/" + nsPrefix + "New_Delivery");
			//https://na1.salesforce.com/services/data/v28.0/sobjects/Account/quickActions/CreateContact
        };
          
        var createDelivery = function( quickAction, uri ) {
        	console.log("Calling POST to create new delivery item.\n" + JSON.stringify(quickAction));;
        	Sfdc.canvas.client.ajax(uri,
        			{
        				client : sr.client,		
        				method: 'POST',
        				contentType: "application/json",
        				data: JSON.stringify(quickAction),
        				success : function(data) {
        					console.log("Got response for delivery item POST");
        					if (201 === data.status) {
        						_.each(orders, function(order) {
        							$("#confirmProdList").append("<li class='list-group-item'>" + order.name + " - " + order.quantSelected + " units</li>");
        						});
        						$("#mydriver").html(driver[0].Name);
        						$("#acctConfirm").html(activeDelivery[nsPrefix + "Account__r"].Name);
        						$('#modalConfirm').modal('show')
        					} else {
               					console.log("Create delivery error: \n" + JSON.stringify(data.payload, null, 4));
               				}
        				},
        				error: function(data) {
        					console.log("Create delivery error: \n" + JSON.stringify(data.payload, null, 4));
        				}
    				}
        	)
        };

        // Andrew's 2nd query
        //        nearbyDeliverySOQL        = 'SELECT OwnerId, Name, Scheduled_Time__c, Owner.Name FROM Delivery__c WHERE OwnerId != :userId AND Status__c != \'Delivered\' AND Status__c != \'Exception\' AND DAY_ONLY(convertTimezone(Scheduled_Time__c)) = :today ORDER BY DISTANCE(Location__c,GEOLOCATION(' + lat + ',' + lon + '),\'mi\') ASC LIMIT 1';

            var selectedProduct = 'Bacon Bits';
			var deliveryId = 'a00R0000000iMCj';
			
			var submitOrder = function() {
				console.log("Called 'submitOrder' and now calling 'getDelivery' method");
				getDelivery(deliveryId);
				console.log("Exiting 'submitOrder' method");
			};
			
            var setQuantity = function(prodName) {
            	console.log("Called 'setQuantity' method with prodName=" + prodName);
                selectedProduct = prodName;
                var prod = baconProducts[selectedProduct];
                if (prod.deliveryToday === true) {
                	$('#quantHeader').html('How much ' + selectedProduct + '?');
                	
                    $('#quantityModal').modal( { show:true });
                } else {
                    alert("This product, while in stock, cannot be delivered today.");
                }
                console.log("exiting 'setQuantity' method");
            };

            var setProductQuantity = function(selectedProduct, value, section) {
            	console.log("Setting quantity");
                var quant = value;
                var prod = baconProducts[selectedProduct];
                prod.quantSelected = quant;
                if ($('#prodList li').length == 0) {
                    $("#prodList").append('<li class="list-group-item">(' + quant + ') ' + prod.name + '</li>');
                    $("#ordertitle").html("Order Info");
                    $("#prodList").show();
                    $("#footer").show();
                } else {
                    $("#prodList li:last").before('<li class="list-group-item">(' + quant + ') ' + prod.name + '</li>');
                }
                orders.push(prod);
                console.log("Hiding 'quantityModal'");
				$("#" + section).collapse('hide');
                console.log("Exiting 'setProductQuantity' method");
            };

            var findAccount = function(arr, name) {
            	var foundAccount = arr[0];
            	_.each(arr, function(el) {
            		if (el[nsPrefix + "Account__r"].Name === name) {
            			foundAccount = el;
            		}
            	})
            	return foundAccount;
            };
            
            var changeAccount = function(acctName) {
            	var delivery = findAccount(nearbyDeliveries, acctName);
            	var account = delivery
                $("#acctName").html(acctName);
                $("#acctStreet").html(delivery[nsPrefix + "Street__c"]);
                $("#acctCityStateZip").html(account[nsPrefix + 'City__c'] + ", " + delivery[nsPrefix + "State__c"] + " " + delivery[nsPrefix + "Postal_Code__c"]);
                $("#acctPhone").html(account[nsPrefix + "Phone__c"]);
                $('#myModal').modal('hide')     
                activeDelivery = delivery;
            };

            var orders = [];

            var baconProducts = {
                'Bacon Bits': {
                    name:'Bacon Bits',
                    inventory:32,
                    quantSelected:0,
                    deliveryToday: true
                },
                'Maple Bacon': {
                    name: 'Maple Bacon',
                    inventory:10,
                    quantSelected:0,
                    deliveryToday: false
                },
                'Smoked Bacon': {
                    name: 'Smoked Bacon',
                    inventory:12,
                    quantSelected:0,
                    deliveryToday: false
                },
                'Thin Bacon': {
                    name: 'Thin Bacon',
                    inventory:12,
                    quantSelected:0,
                    deliveryToday: true
                },
            }
        </script>
    </body>
</html>
