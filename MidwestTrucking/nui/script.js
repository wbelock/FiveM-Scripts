window.addEventListener('message', function(data) {
    data = data.data;
    console.log(data);
    const event = data.event;

    switch (event) {
        case "updateStatus":
            // 
            $("#enRoute")[0].innerText = data.message;
            break;

        case "updateHelpText":
            // 
            $("#helpText")[0].innerText = data.message;
            break;

        case "updateStopsLeft":
            //
            $("#stopsLeft")[0].innerText = data.message;
            break;         

        case "setVisibility":
            // We change the visibility of the NUI
            (data.visibility ? $('.mainBody').show() : $('.mainBody').hide())
            break;
            
        case "setManifestWeights":
            // We change the Manifest of the NUI
            let response = data.message;
            let manifestOptions = response.split(' ');
            console.log(manifestOptions);
            $("#firstNum")[0].innerText = manifestOptions[0];
            $("#secondNum")[0].innerText = manifestOptions[1];
            $("#thirdNum")[0].innerText = manifestOptions[2];
            $("#fourthNum")[0].innerText = manifestOptions[3];
            $("#fifthNum")[0].innerText = manifestOptions[4];
            break;

        case "setManifestItems":
            // We change the Manifest of the NUI
            let responseItems = data.message;
            const comma = ','
            let manifestItems = responseItems.split(comma);
            console.log(manifestItems);
            $("#firstItem")[0].innerText = manifestItems[0];
            $("#secondItem")[0].innerText = manifestItems[1];
            $("#thirdItem")[0].innerText = manifestItems[2];
            $("#fourthItem")[0].innerText = manifestItems[3];
            $("#fifthItem")[0].innerText = manifestItems[4];
            break;    

        default:
            break;
    }
});