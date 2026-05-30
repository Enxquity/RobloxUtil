local RestaurantClient = require(game:GetService("ReplicatedStorage").Framework.Client.ClientRestaurant)
local EntitiesClient = require(game:GetService("ReplicatedStorage").Framework.Client.ClientEntity)

function GetRestaurant()
    for _, RestaurantData in RestaurantClient.All() do
        if RestaurantData:IsLocal() then
            return RestaurantData
        end
    end
end

local PlayerRestaurant = GetRestaurant()
local RestaurantModel = PlayerRestaurant:GetModel()
local Entities = RestaurantModel:FindFirstChild("Entities")

for _, EntityModel in Entities:GetChildren() do
    local Entity = EntitiesClient.FromModel(EntityModel)
    print(`{EntityModel.Name} ID: {Entity:GetId()}`)
end
