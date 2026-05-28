package com.servlet;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Paths;

import com.beans.ProductBean;
import com.dao.DAOInterface;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 10,     // 10 MB
    maxRequestSize = 1024 * 1024 * 15   // 15 MB
)
public class UpdateProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("========== UPDATE PRODUCT SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if(session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/signIn.jsp");
            return;
        }
        
        try {
            // Get form parameters from multipart form
            String productId = getParameterFromPart(request, "productId");
            String productName = getParameterFromPart(request, "productName");
            String productPrice = getParameterFromPart(request, "productPrice");
            String productQuantity = getParameterFromPart(request, "productQuantity");
            String productCategory = getParameterFromPart(request, "productCategory");
            String productDescription = getParameterFromPart(request, "productDescription");
            
            // DEBUG PRINTS
            System.out.println("===== RECEIVED VALUES =====");
            System.out.println("productId: '" + productId + "'");
            System.out.println("productName: '" + productName + "'");
            System.out.println("productPrice: '" + productPrice + "'");
            System.out.println("productQuantity: '" + productQuantity + "'");
            System.out.println("productCategory: '" + productCategory + "'");
            System.out.println("productDescription: '" + productDescription + "'");
            System.out.println("===========================");
            
            // Validate required fields
            if(productId == null || productId.trim().isEmpty()) {
                System.out.println("ERROR: Product ID is required");
                response.sendRedirect(request.getContextPath() + "/admin/products.jsp?error=idrequired");
                return;
            }
            
            if(productName == null || productName.trim().isEmpty()) {
                System.out.println("ERROR: Product name is required");
                response.sendRedirect(request.getContextPath() + "/admin/editProduct.jsp?id=" + productId + "&error=namerequired");
                return;
            }
            
            if(productPrice == null || productPrice.trim().isEmpty()) {
                System.out.println("ERROR: Product price is required");
                response.sendRedirect(request.getContextPath() + "/admin/editProduct.jsp?id=" + productId + "&error=pricerequired");
                return;
            }
            
            if(productQuantity == null || productQuantity.trim().isEmpty()) {
                System.out.println("ERROR: Product quantity is required");
                response.sendRedirect(request.getContextPath() + "/admin/editProduct.jsp?id=" + productId + "&error=quantityrequired");
                return;
            }
            
            // Get DAO object first to fetch existing product (for image)
            DAOInterface DAOobj = (DAOInterface) getServletContext().getAttribute("DAOobj");
            
            if(DAOobj == null) {
                System.out.println("ERROR: DAO object is null");
                response.sendRedirect(request.getContextPath() + "/admin/products.jsp?error=system");
                return;
            }
            
            // Fetch existing product to get current image
            ProductBean existingProduct = DAOobj.getProductById(Integer.parseInt(productId));
            
            // Handle file upload
            Part filePart = request.getPart("productImage");
            String fileName = existingProduct.getP_Image(); // Keep existing image by default
            
            if(filePart != null && filePart.getSize() > 0) {
                // Get the original filename
                fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                System.out.println("New uploaded file name: " + fileName);
                
                // Define upload path
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                    System.out.println("Created upload directory: " + uploadPath);
                }
                
                // Save the file
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                System.out.println("File saved to: " + filePath);
                
                // Optional: Delete old image if it's not the default
                if(existingProduct.getP_Image() != null && !existingProduct.getP_Image().equals("placeholder.jpg")) {
                    File oldFile = new File(uploadPath + File.separator + existingProduct.getP_Image());
                    if(oldFile.exists()) {
                        oldFile.delete();
                        System.out.println("Deleted old image: " + existingProduct.getP_Image());
                    }
                }
            }
            
            // Create ProductBean with updated values
            ProductBean product = new ProductBean();
            product.setP_ID(productId);
            product.setP_Name(productName);
            product.setP_Price(productPrice);
            product.setP_Quantity(productQuantity);
            product.setP_Image(fileName);
            
            System.out.println("Product bean created with values:");
            System.out.println("  ID: " + product.getP_ID());
            System.out.println("  Name: " + product.getP_Name());
            System.out.println("  Price: " + product.getP_Price());
            System.out.println("  Quantity: " + product.getP_Quantity());
            System.out.println("  Image: " + product.getP_Image());
            
            // Update product in database
            boolean updated = DAOobj.updateProduct(product);
            
            if(updated) {
                System.out.println("Product updated successfully to database");
                response.sendRedirect(request.getContextPath() + "/admin/products?success=updated");
            } else {
                System.out.println("Failed to update product in database");
                response.sendRedirect(request.getContextPath() + "/admin/editProduct.jsp?id=" + productId + "&error=updatefailed");
            }
            
        } catch(Exception e) {
            System.out.println("Exception in UpdateProductServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products.jsp?error=exception");
        }
    }
    
    /**
     * Helper method to get parameter value from multipart form
     */
    private String getParameterFromPart(HttpServletRequest request, String paramName) 
            throws IOException, ServletException {
        Part part = request.getPart(paramName);
        if(part != null && part.getSize() > 0) {
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(part.getInputStream(), "UTF-8"))) {
                return reader.readLine();
            }
        }
        return null;
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}