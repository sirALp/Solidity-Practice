// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleStorage{
    // boolean , uint , int ,address,bytes

    //it's set to internal default , we do need to state its public
    uint256 favoriteNumber;

    struct People{
        uint256 favoriteNumber;
        string name;
    }

    /*
    People public person1 = People({favoriteNumber: 2,name :"Patrick"});
    People public person2 = People({favoriteNumber: 6,name :"Alp"});
    People public person3 = People({favoriteNumber: 2,name :"Baris"});
    */
    //instead we can use arrays
    People[] public people; //on deploy screen:
                            // it'd return the content at that index when we deploy
    
    mapping (string => uint256) public nameToFavoriteNumber;



    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;   
    }

    // view , pure
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    function add() public pure returns(uint256){
        return (1+1);
    }

    function addPeople(string memory _name,uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber,_name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }


}
//0xd9145CCE52D386f254917e481eB44e9943F39138