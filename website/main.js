const serverUrl="https://fjtqfrution4.usemoralis.com:2053/server";
const appId="wmRS0a9m4VltjogBEQOi3ubp9li0I7DxHbDOqY5o";
Moralis.start({serverUrl,appId});
                 I
// Add from here down
async function Login(){
  let user=Moralis.User.current();
  if(!user){
  try{
      user= await Moralis.authenticate({signingMessage:"Authenticate"});
      await Moralis.enableWeb3();
      console.log(user);
      console.log(user.get('ethAddress'));
   } catch(error){
     console.log(error)
   }
}
}

async function logOut() {
  await Moralis.User.logOut();
  console.log("logged out");
}

async function donate{
    let options = {
        contractAddress:"0x6b3Ec2Fee2FCE6ea5bAe288107D790A94a22A48A";
        functionName:"fundEth";
        Abi:[];
        params:{
            // inputs of function 
        }
        msgValue
    }
    await Moralis.executeFunction(options); 
}

document.getElementById("btn-login").onclick=login;
document.getElementById("btn-logout").onclick=logout;
document.getElementById("btn-donate").onclick=logout;