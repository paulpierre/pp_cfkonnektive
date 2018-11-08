/**
 *  =============================================
 *  Click Funnels + Konnektive Integration Script
 *  by twitter.com/paulpierre - 10/3/2018
 *  =============================================
 *  TL;DR this script allows you to enjoy the quick design iteration of click funnels while
 *  processing orders securely through Konnektive, enjoying load balancing and anti-fraud where CF falls short
 */



var cg_redirect,cg_order_id,cg_config;


/**
 *  Configuration
 */

var cg_order_bump = [{CG_ORDER_BUMP}],           //product ID of the order bump
    cg_lander_prefix ="{CG_LANDER_PREFIX}",     //this is the lander prefix for CF, e.g. ~/coolair-order ~/coolair-oto-1, etc.
    cg_lander_name = "{CG_LANDER_NAME}",
    _path, cg_domain,cg_oto_count,cg_oto_step,cg_upsells;


//lets wait until the document loads
$(document).ready(function(){


    if(typeof page_type == "undefined")
        console.log("CF + EF tracking not available. this page will not function");


    cg_domain =  ((document.domain.split(".")[1]) + "." + (document.domain.split(".")[2])); //, _ = cg_campaign.webPages.checkoutPage.url.split("/")[2].split("."); cg_domain = _["1"] + "." + _["2"];

    //konnektive configuration
    cg_config = {
        git_domain:     "secure."   + cg_domain ,
        cf_domain:      (document.domain.split(".")[0]) + "."      + cg_domain,

        /** ------------------------------
         *  PLEASE EDIT THIS CONFIGURATION
         *  ------------------------------
         */
        git_funnel:     cg_lander_name,   //this is the name of the funnel folder on git
        lander_prefix:  cg_lander_prefix,          //this is the prefix in the vanity URL domain
        product_map:
            {
                order:     [],      //these will be in order of the selection in a dropdown or selection
                order_bump: cg_order_bump,              //order bump on the ORDER page, use only one
            }
    }

    _path = "https://secure." + cg_domain+ "/funnels/" + cg_lander_name + "/";

//this is highly dependent on CF + Everflow script

    console.log("*** CG checkout.js loaded - " + page_type);

    //Lets make sure tracking script is running
    switch(page_type)
    {
        case "order":

            $("#cfAR").remove();
            $("div.containerWrapper").wrap("<form id='kform' class='kform kform_kcartCheckout' onsubmit='return false;'></form>");
            $("[name='first_name']").prop("name","firstName").prop("isRequired","").prop("type","text");
            $("[name='last_name']").prop("name","lastName").prop("isRequired","").prop("type","text");
            $("[name='email']").prop("name","emailAddress").prop("isRequired","").prop("type","text");
            $("[name='phone']").prop("name","phoneNumber").prop("isRequired","").prop("type","text");
            $("[name='address']").prop("name","address1").prop("isRequired","").prop("type","text");
            $("[name='city']").prop("isRequired","").prop("type","text");
            $("[name='state']").prop("isRequired","").prop("type","text");
            $("[name='country']").prop("isRequired","").prop("type","text");

            //TODO: add country targeting code!
            $("option[value='United States']").prop("value","US");

            $("[name='zip']").prop("name","postalCode").prop("isRequired","").prop("type","text").html("<input name='billShipSame' type='CHECKBOX' checked><div id='kform_hiddenAddress'>" +
                "                        <input name='shipAddress1' type='TEXT' isRequired>" +
                "                        <input name='shipAddress2' type='TEXT'>" +
                "                        <input name='shipCity' type='TEXT' isRequired>" +
                "                        <select name='shipState' isRequired>" +
                "                        </select>" +
                "                        <select name='shipCountry'></select>" +
                "                        <input name='shipPostalCode' type='TEXT' isRequired>" +
                "<input type='hidden' name='orderItems' value=''></div><input type='hidden' name='paySource' value='CREDITCARD'>");


            $("input.cc-number").prop("name","cardNumber").prop("isRequired","").prop("type","text");
            $("input.cc-cvc").prop("name","cardSecurityCode").prop("isRequired","").prop("type","text");
            $("select.cc-expirey-month").prop("name","cardMonth").prop("isRequired","").prop("type","text");
            $("select.cc-expirey-year").prop("name","cardYear").prop("isRequired","").prop("type","text");
            $("a[href='#submit-form']").hide();
            $("a[href='#submit-form']").parent().append("<input type='button' value='Order Now' class='kform_submitBtn elButton elButtonSize1 elButtonColor1 elButtonRounded elButtonPadding2 elBtnVP_10 elButtonCorner3 elBtnHP_25 elBTN_b_1 elButtonShadowN1 elButtonTxtColor1 elButtonBlock elButtonNoShadow elButtonFull' style='color: rgb(255, 255, 255); background-color: rgb(66, 210, 27); font-size: 20px;' id='kformSubmit'>");



            //Lets inject all the Konnektive code after we've modified all the forms
            var s1, s2, s3, s4;

            s1 = document.createElement('script');
            s1.src = _path + "resources/js/kvalidator.js";
            document.getElementsByTagName('head')[0].appendChild(s1);

            s2 = document.createElement('script');
            s2.src = _path + "resources/js/klander.js";
            document.getElementsByTagName('head')[0].appendChild(s2);

            s3 = document.createElement('script');
            s3.src = _path + "resources/js/kcart.js";
            document.getElementsByTagName('head')[0].appendChild(s3);

            s4 = document.createElement('script');
            s4.src = _path + "js.php?p=checkout";
            document.getElementsByTagName('head')[0].appendChild(s4);


            s4.onload = function() {
                //lets add the order item
                $("#kform").append("<input type='checkbox' value='" + (cg_campaign.offers[Object.keys(cg_campaign.offers)[0]].productId) + "' quantity='1' id='cartItems' class='kformCheckoutUpsell' style='display:none;' checked>");


                //setTimeout(function(){
                cg_config.product_map.order =  get_keys(cg_campaign.offers);


                //bump offer #173

                if(cg_order_bump)
                {
                    $("input#bump-offer").prop("value",cg_order_bump[0]).prop("quantity","0").prop("class","kformCheckoutUpsell");

                    $("input#bump-offer").click(function(o){
                        if($(this).is(":checked")) $(this).prop("quantity","1"); else $(this).prop("quantity","0");
                    });

                    if($(this).is(":checked")) $(this).prop("quantity","1"); else $(this).prop("quantity","0");
                }




                //Lets setup the click handler and let the product map itself
                setTimeout(function(){
                    $("div.elOrderProductOptinProductName input").each(function(index){
                        console.log("index: " + index + " checked: " + $(this).is(':checked'))
                        if($(this).is(':checked')) { $("#cartItems").attr("value",cg_config.product_map.order[index]);}
                        $(this).attr("index",index).parent().click(function(o){
                            console.log("product ID selected: " + cg_config.product_map.order[parseInt($(this).attr("index"))]);
                            $("#cartItems").attr("value",cg_config.product_map.order[parseInt($(this).attr("index"))]);
                        });
                    });
                },1000);


                //cg_redirect = "https://www.ultracoolair.co/coolair-oto-1";
                //},500);

                cg_redirect = "https://" + cg_config.cf_domain + "/" + cg_config.lander_prefix + "-oto-1";


                kform_formSubmitCallback = function(response, success)
                {
                    window.location = cg_redirect;
                    return !success;
                }

            }


            break;

        case "oto":


            cg_oto_step =(parseInt(window.location.pathname.split("/").pop().split("-")[1]) === parseInt(window.location.pathname.split("/").pop().split("-")[1], 10))? parseInt(window.location.pathname.split("/").pop().split("-")[1]):false;


            var oto_product_id = 0;


            $("#cfAR").remove();
            $("div.containerWrapper").wrap("<form id='kform'  onsubmit='return false;'></form>");

            $("[href='#yes-link']").hide().parent().append('<input type="hidden" name="orderId" value="' + rc('cg_order_id') + '" noSaveFormValue readonly><input type="hidden" name="productId" id="oto_product" value="' + oto_product_id + '" noSaveFormValue readonly/><input type="button" value="Add 1 More CoolAir" class="elButton elButtonSize1 elButtonColor1 elButtonRounded elButtonPadding2 elBtnVP_10 elButtonFluid elBtnHP_25 elBTN_b_1_3 elButtonShadowN3 elButtonTxtColor2 elBTNone elButtonBlock mfs_16 elButtonCorner10 kform_upsellBtn" style="color: rgb(255, 255, 255); background-color: rgb(69, 201, 54); font-size: 18px;"  id="kformSubmit"/>');
            $("[href='#no-link']").prop("id","").attr("href",cg_redirect);


            var s1, s2, s3, s4;

            s1 = document.createElement('script');
            s1.src = _path + "resources/js/kvalidator.js";
            document.getElementsByTagName('head')[0].appendChild(s1);

            s2 = document.createElement('script');
            s2.src = _path + "resources/js/klander.js";
            document.getElementsByTagName('head')[0].appendChild(s2);

            s3 = document.createElement('script');
            s3.src = _path + "resources/js/kcart.js";
            document.getElementsByTagName('head')[0].appendChild(s3);

            s4 = document.createElement('script');
            s4.src = _path + "js.php?p=oto" + cg_oto_step;
            document.getElementsByTagName('head')[0].appendChild(s4);

            s4.onload = function() {

                setTimeout(function(){

                    /*
                    cg_upsells = get_keys(cg_campaign.upsells);
                    cg_oto_count = (Object.keys(cg_campaign.webPages).length - 4); //cg_upsells.length;// Object.keys(cg_config.product_map).length - 2;

                    for(var i=0;i<=cg_oto_count-1;i++)
                    {
                        cg_config.product_map["oto" + (i+1)] = cg_upsells[i];
                    }

                    $("#oto_product").attr("value",cg_upsells[cg_oto_step -1]) ;
                    */

                    var _key;
                    switch(cg_oto_step)
                    {
                        case 1: _key = "upsellPage1"; break;
                        case 2: _key = "upsellPage2"; break;
                        case 3: _key = "upsellPage3"; break;
                        case 4: _key = "upsellPage4"; break;
                        case 5: _key = "upsellPage5"; break;
                        case 6: _key = "upsellPage6"; break;
                        case 7: _key = "upsellPage7"; break;
                    }

                    cg_redirect = "https://" + cg_config.cf_domain + "/" + cg_lander_prefix+ "-thankyou";


                    if(typeof cg_campaign.webPages[_key] != "undefined") {
                        $("#oto_product").attr("value",cg_campaign.webPages[_key].productId);
                        if(typeof cg_campaign.webPages["upsellPage" + (cg_oto_step + 1)] != "undefined" )cg_redirect = "https://" + cg_config.cf_domain + "/" + cg_lander_prefix + "-oto-" + (cg_oto_step +1);


                    }
                    /*
                    //If there is no next OTO step, lets send them over to the thank you page
                    if(typeof cg_config.product_map["oto" + (cg_oto_step + 1)] == "undefined")
                        cg_redirect = "https://" + cg_config.cf_domain + "/" + cg_lander_prefix+ "-thankyou"
                    else */

                    kform_formSubmitCallback = function(response, success)
                    {
                        window.location = cg_redirect;
                        return !success;
                    }
                },500);
            }


            break;
    }


    //lets set the redirects




});

function get_keys(obj) {
    var keys = [], name;
    for (name in obj) {
        keys.push(name);

    }
    return keys;
}


function wc(cname, cvalue)
{
    var d = new Date();
    d.setTime(d.getTime() + (7 * 24 * 60 * 60 * 1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function rc(cname)
{
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return false;
}

function uparam(name, url) {
    if (!url) url = window.location.href;
    if(!name) return null;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}
