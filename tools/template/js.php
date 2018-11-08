<?php
session_start();
header("Access-Control-Allow-Origin: *");
//header('Content-Type: application/javascript');
require_once realpath(dirname(__FILE__)."/resources/konnektiveSDK.php");

switch($_GET['p'])
{
    case 'checkout':
        $pageType = "checkoutPage"; //choose from: presalePage, leadPage, checkoutPage, upsellPage1, upsellPage2, upsellPage3, upsellPage4, thankyouPage
        $deviceType = "ALL"; //choose from: DESKTOP, MOBILE, ALL
        $ksdk = new KonnektiveSDK($pageType,$deviceType);
        exit($ksdk->echoJS() . " var cg_campaign = " . KFormConfig::$campaignData);
        break;

    case 'oto1':
        $pageType = "upsellPage1"; //choose from: presalePage, leadPage, checkoutPage, upsellPage1, upsellPage2, upsellPage3, upsellPage4, thankyouPage
        $deviceType = "ALL"; //choose from: DESKTOP, MOBILE, ALL
        $ksdk = new KonnektiveSDK($pageType,$deviceType);
        $productId = $ksdk->page->productId;
        $upsell = $ksdk->getProduct((int) $productId);
        exit($ksdk->echoJS(). " var cg_campaign = " . KFormConfig::$campaignData);
        break;


    case 'oto2':
        $pageType = "upsellPage2"; //choose from: presalePage, leadPage, checkoutPage, upsellPage1, upsellPage2, upsellPage3, upsellPage4, thankyouPage
        $deviceType = "ALL"; //choose from: DESKTOP, MOBILE, ALL
        $ksdk = new KonnektiveSDK($pageType,$deviceType);
        $productId = $ksdk->page->productId;
        $upsell = $ksdk->getProduct((int) $productId);
        exit($ksdk->echoJS(). " var cg_campaign = " . KFormConfig::$campaignData);
        break;

    case 'oto3':
        $pageType = "upsellPage3"; //choose from: presalePage, leadPage, checkoutPage, upsellPage1, upsellPage2, upsellPage3, upsellPage4, thankyouPage
        $deviceType = "ALL"; //choose from: DESKTOP, MOBILE, ALL
        $ksdk = new KonnektiveSDK($pageType,$deviceType);
        $productId = $ksdk->page->productId;
        $upsell = $ksdk->getProduct((int) $productId);
        exit($ksdk->echoJS(). " var cg_campaign = " . KFormConfig::$campaignData);
        break;

    case 'oto4':
        $pageType = "upsellPage4"; //choose from: presalePage, leadPage, checkoutPage, upsellPage1, upsellPage2, upsellPage3, upsellPage4, thankyouPage
        $deviceType = "ALL"; //choose from: DESKTOP, MOBILE, ALL
        $ksdk = new KonnektiveSDK($pageType,$deviceType);
        $productId = $ksdk->page->productId;
        $upsell = $ksdk->getProduct((int) $productId);

        exit($ksdk->echoJS(). " var cg_campaign = " . KFormConfig::$campaignData);
        break;



    default:
        exit("//nope");
        break;
}


?>









