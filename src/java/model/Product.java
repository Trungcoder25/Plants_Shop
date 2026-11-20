/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class Product {

    private int id;
    private String name;
    private String image;
    private double price;
    private double oldPrice;
    private int stock;
    private String plantHeight;
    private String lightLevel;
    private String waterFrequency;
    private String careDifficulty;
    private String description;
    private String careGuide;
    private boolean featured;
    private int categoryId;
    private String categoryName;

    public Product() {}

    public int getId() {return id;}

    public void setId(int id) {this.id = id;}

    public String getName() {return name;}

    public void setName(String name) {this.name = name;}

    public String getImage() {return image;}

    public void setImage(String image) {this.image = image;}

    public double getPrice() {return price;}

    public void setPrice(double price) {this.price = price;}

    public double getOldPrice() {return oldPrice;}

    public void setOldPrice(double oldPrice) {this.oldPrice = oldPrice;}

    public int getStock() {return stock;}

    public void setStock(int stock) {this.stock = stock;}

    public String getPlantHeight() {return plantHeight;}

    public void setPlantHeight(String plantHeight) {this.plantHeight = plantHeight;}

    public String getLightLevel() {return lightLevel;}

    public void setLightLevel(String lightLevel) {this.lightLevel = lightLevel;}

    public String getWaterFrequency() {return waterFrequency;}

    public void setWaterFrequency(String waterFrequency) {this.waterFrequency = waterFrequency;}

    public String getCareDifficulty() {return careDifficulty;}

    public void setCareDifficulty(String careDifficulty) {this.careDifficulty = careDifficulty;}

    public String getDescription() {return description;}

    public void setDescription(String description) {this.description = description;}

    public String getCareGuide() {return careGuide;}

    public void setCareGuide(String careGuide) {this.careGuide = careGuide;}

    public boolean isFeatured() {return featured;}

    public void setFeatured(boolean featured) {this.featured = featured;}

    public int getCategoryId() {return categoryId;}

    public void setCategoryId(int categoryId) {this.categoryId = categoryId;}

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

}
