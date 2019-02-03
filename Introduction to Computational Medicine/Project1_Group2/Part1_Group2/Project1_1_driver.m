clear all; close all; clc;

%% Visualizing Atlas
% load landmark and surface data for amygdala and hippocampus
lA1 = read_txt_landmarks('amygdala_01_landmarks.txt');
lH1 = read_txt_landmarks('hippocampus_01_landmarks.txt');
[fA1,vA1] = read_byu_surface('amygdala_01_surface.byu');
[fH1,vH1] = read_byu_surface('hippocampus_01_surface.byu');

% view the landmarks using scatter3
figure
hlA1 = scatter3(lA1(:,1),lA1(:,2),lA1(:,3));
hold on;
hlH1 = scatter3(lH1(:,1),lH1(:,2),lH1(:,3));

% view the surfaces using the patch command
hsA1 = patch('faces',fA1,'vertices',vA1);
hsH1 = patch('faces',fH1,'vertices',vH1);

% fix the axes so x-y-z do not rescale independently
axis image
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
% add a light to visualize 3D surfaces with shading
light
% find a nice orientation
view(64,26)
% color the data to make it more interpretable
% feel free to display it any way you think is best
set(hlA1,'MarkerFaceColor','c','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH1,'MarkerFaceColor','y','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA1,'FaceColor','c','EdgeColor','none','FaceLighting','phong')
set(hsH1,'FaceColor','y','EdgeColor','none','FaceLighting','phong')
% more formatting to make the figure pretty
set(gca,'LineWidth',2,'Box','on','FontSize',12)
legend([hsA1, hsH1], {'Amygdala', 'Hippocampus'}, 'Location', 'best');
% save the figure
set(gcf,'PaperPositionMode','auto')
saveas(gcf,'Atlas.png')
hold off

%% Visualizing Target
% load landmark and surface data for amygdala and hippocampus
lA2 = read_txt_landmarks('amygdala_05_landmarks.txt');
lH2 = read_txt_landmarks('hippocampus_05_landmarks.txt');
[fA2,vA2] = read_byu_surface('amygdala_05_surface.byu');
[fH2,vH2] = read_byu_surface('hippocampus_05_surface.byu');

% view the landmarks using scatter3
figure
hlA2 = scatter3(lA2(:,1),lA2(:,2),lA2(:,3));
hold on;
hlH2 = scatter3(lH2(:,1),lH2(:,2),lH2(:,3));

% view the surfaces using the patch command
hsA2 = patch('faces',fA2,'vertices',vA2);
hsH2 = patch('faces',fH2,'vertices',vH2);

% fix the axes so x-y-z do not rescale independently
axis image
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
% add a light to visualize 3D surfaces with shading
light
% find a nice orientation
view(64,26)
% color the data to make it more interpretable
% feel free to display it any way you think is best
set(hlA2,'MarkerFaceColor','c','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH2,'MarkerFaceColor','y','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA2,'FaceColor','c','EdgeColor','none','FaceLighting','phong')
set(hsH2,'FaceColor','y','EdgeColor','none','FaceLighting','phong')
% more formatting to make the figure pretty
set(gca,'LineWidth',2,'Box','on','FontSize',12)
% save the figure
set(gcf,'PaperPositionMode','auto')
legend([hsA2, hsH2], {'Amygdala', 'Hippocampus'}, 'Location', 'best');
saveas(gcf,'Target.png')
hold off

%% Visualizing Overlaid Atlas and Target
% load landmark and surface data for amygdala and hippocampus
lA1 = read_txt_landmarks('amygdala_01_landmarks.txt');
lH1 = read_txt_landmarks('hippocampus_01_landmarks.txt');
[fA1,vA1] = read_byu_surface('amygdala_01_surface.byu');
[fH1,vH1] = read_byu_surface('hippocampus_01_surface.byu');

% view the landmarks using scatter3
figure
hlA1 = scatter3(lA1(:,1),lA1(:,2),lA1(:,3));
hold on;
hlH1 = scatter3(lH1(:,1),lH1(:,2),lH1(:,3));
hlA2 = scatter3(lA2(:,1),lA2(:,2),lA2(:,3));
hold on;
hlH2 = scatter3(lH2(:,1),lH2(:,2),lH2(:,3));


% view the surfaces using the patch command
hsA1 = patch('faces',fA1,'vertices',vA1);
hsH1 = patch('faces',fH1,'vertices',vH1);
hsA2 = patch('faces',fA2,'vertices',vA2);
hsH2 = patch('faces',fH2,'vertices',vH2);

% fix the axes so x-y-z do not rescale independently
axis image
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
% add a light to visualize 3D surfaces with shading
light
% find a nice orientation
view(64,26)
% color the data to make it more interpretable
% feel free to display it any way you think is best
set(hlA1,'MarkerFaceColor','c','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH1,'MarkerFaceColor','y','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA1,'FaceColor','c','EdgeColor','none','FaceLighting','phong')
set(hsH1,'FaceColor','y','EdgeColor','none','FaceLighting','phong')
set(hlA2,'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH2,'MarkerFaceColor','g','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA2,'FaceColor','r','EdgeColor','none','FaceLighting','phong')
set(hsH2,'FaceColor','g','EdgeColor','none','FaceLighting','phong')
% more formatting to make the figure pretty
set(gca,'LineWidth',2,'Box','on','FontSize',12)
legend([hsA1, hsH1, hsA2, hsH2], {'A-Amygdala', 'A-Hippocampus', 'T-Amygdala', 'T-Hippocampus'}, 'Location', 'northwest');
% save the figure
set(gcf,'PaperPositionMode','auto')
saveas(gcf,'Overlaid No Transform.png')
hold off

%% Linear Alignment Calculation via SS Error Minimization
% form of Ba=D where A is unknown

X = transpose(vertcat(lA1, lH1));
Y = transpose(vertcat(lA2, lH2));

B = zeros(9,9);
D = zeros(9,1);
for i = 1:size(X,2)
    X_reshaped = [X(1,i) X(2,i) X(3,i) 0      0      0      0      0      0;
                  0      0      0      X(1,i) X(2,i) X(3,i) 0      0      0;
                  0      0      0      0      0      0      X(1,i) X(2,i) X(3,i)];
    B = B + (transpose(X_reshaped) * X_reshaped);
    D = D + (transpose(X_reshaped) * Y(:, i));
end

a = mldivide(B, D);
A = transpose(reshape(a, [3,3]))
Xtrans = A*X;
save('Transformation Matrix','A')

% calculating sum of squared errors
preError = 0;
for i = 1:size(X,2)
    preError = preError + (norm(X(:,i) - Y(:,i)))^2;
end
preError

postError = 0;
for i = 1:size(Xtrans,2)
    postError = postError + (norm(Xtrans(:,i) - Y(:,i)))^2;
end
postError

% transforming atlas - we transform V but leave F alone

lA1_lin = transpose(A*transpose(lA1));
lH1_lin = transpose(A*transpose(lH1));
vA1_lin = transpose(A*transpose(vA1));
vH1_lin = transpose(A*transpose(vH1));

%% Visualizing Linear Alignment Transformation
% view the landmarks using scatter3
figure
hlA3 = scatter3(lA1_lin(:,1),lA1_lin(:,2),lA1_lin(:,3));
hold on;
hlH3 = scatter3(lH1_lin(:,1),lH1_lin(:,2),lH1_lin(:,3));

% view the surfaces using the patch command
hsA3 = patch('faces',fA1,'vertices',vA1_lin);
hsH3 = patch('faces',fH1,'vertices',vH1_lin);

% fix the axes so x-y-z do not rescale independently
axis image
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
% add a light to visualize 3D surfaces with shading
light
% find a nice orientation
view(64,26)
% color the data to make it more interpretable
% feel free to display it any way you think is best
set(hlA3,'MarkerFaceColor','c','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH3,'MarkerFaceColor','y','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA3,'FaceColor','c','EdgeColor','none','FaceLighting','phong')
set(hsH3,'FaceColor','y','EdgeColor','none','FaceLighting','phong')
% more formatting to make the figure pretty
set(gca,'LineWidth',2,'Box','on','FontSize',12)
legend([hsA3, hsH3], {'Amygdala', 'Hippocampus'}, 'Location', 'best');
% save the figure
set(gcf,'PaperPositionMode','auto')
saveas(gcf,'Atlas Linearly Transformed.png')
hold off

%% Visualizing Overlaid Linearly Transformed Atlas and Target
% view the landmarks using scatter3
figure
hlA3 = scatter3(lA1_lin(:,1),lA1_lin(:,2),lA1_lin(:,3));
hold on;
hlH3 = scatter3(lH1_lin(:,1),lH1_lin(:,2),lH1_lin(:,3));
hlA2 = scatter3(lA2(:,1),lA2(:,2),lA2(:,3));
hlH2 = scatter3(lH2(:,1),lH2(:,2),lH2(:,3));

% view the surfaces using the patch command
hsA3 = patch('faces',fA1,'vertices',vA1_lin);
hsH3 = patch('faces',fH1,'vertices',vH1_lin);
hsA2 = patch('faces',fA2,'vertices',vA2);
hsH2 = patch('faces',fH2,'vertices',vH2);

% fix the axes so x-y-z do not rescale independently
axis image
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
% add a light to visualize 3D surfaces with shading
light
% find a nice orientation
view(64,26)
% color the data to make it more interpretable
% feel free to display it any way you think is best
set(hlA3,'MarkerFaceColor','c','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH3,'MarkerFaceColor','y','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA3,'FaceColor','c','EdgeColor','none','FaceLighting','phong')
set(hsH3,'FaceColor','y','EdgeColor','none','FaceLighting','phong')
set(hlA2,'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH2,'MarkerFaceColor','g','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA2,'FaceColor','r','EdgeColor','none','FaceLighting','phong')
set(hsH2,'FaceColor','g','EdgeColor','none','FaceLighting','phong')
% more formatting to make the figure pretty
set(gca,'LineWidth',2,'Box','on','FontSize',12)
legend([hsA3, hsH3, hsA2, hsH2], {'A-Amygdala', 'A-Hippocampus', 'T-Amygdala', 'T-Hippocampus'}, 'Location', 'northwest');
% save the figure
set(gcf,'PaperPositionMode','auto')
saveas(gcf,'Overlaid Linearly Transformed.png')
hold off

%% Calculating P of Spline Transformation
X = vertcat(lA1_lin, lH1_lin);
Y = vertcat(lA2, lH2);
Xsurf = vertcat(vA1_lin, vH1_lin);

V = Y - X;

% figuring out k_hat
sigma = 5;
k_hat = zeros(size(V,1), size(V,1));
for i = 1:size(k_hat,1)% row
    for j = 1:size(k_hat,2) % column
        k_hat(i,j) = exp((-1/(2*sigma^2))*norm(X(i,:)-X(j,:))^2);
    end
end

% solving for P
P = zeros(size(X));
for i = 1:size(P,2)
    P(:,i) = mldivide(k_hat, V(:,i));
end
P
save('p','P');

%% Spline Transformation of Landmarks and Vertices
% transforming the landmarks
v_X = zeros(size(X));
for i = 1:size(X,1) % looping through every point and need creating v to it for each dim
    for j = 1:size(X,1) % for the summation
        v_X(i,1) = v_X(i,1) + exp((-1/(2*sigma^2))*norm(X(i,:)-X(j,:))^2)*P(j,1);
        v_X(i,2) = v_X(i,2) + exp((-1/(2*sigma^2))*norm(X(i,:)-X(j,:))^2)*P(j,2);
        v_X(i,3) = v_X(i,3) + exp((-1/(2*sigma^2))*norm(X(i,:)-X(j,:))^2)*P(j,3);
    end
end

Xtransformed = X + v_X;
lA1_lin_trans = Xtransformed(1:size(lA1_lin,1),:);
lH1_lin_trans = Xtransformed(size(lA1_lin,1)+1:end,:);

% calculating sum of square error
splineError = 0;
for i = 1:size(Xtransformed,1)
    splineError = splineError + (norm(Xtransformed(i,:) - Y(i,:)))^2;
end
splineError

% transforming the surface vectors
v_Xsurf = zeros(size(Xsurf));
for i = 1:size(Xsurf,1) % looping through every point and need creating v to it for each dim
    for j = 1:size(X,1) % for the summation
        v_Xsurf(i,1) = v_Xsurf(i,1) + exp((-1/(2*sigma^2))*norm(Xsurf(i,:)-X(j,:))^2)*P(j,1);
        v_Xsurf(i,2) = v_Xsurf(i,2) + exp((-1/(2*sigma^2))*norm(Xsurf(i,:)-X(j,:))^2)*P(j,2);
        v_Xsurf(i,3) = v_Xsurf(i,3) + exp((-1/(2*sigma^2))*norm(Xsurf(i,:)-X(j,:))^2)*P(j,3);
    end
end

Xsurf_transformed = Xsurf + v_Xsurf;
vA1_lin_trans = Xsurf_transformed(1:size(vA1_lin,1),:);
vH1_lin_trans = Xsurf_transformed(size(vA1_lin,1)+1:end,:);

%% Visualizing Spline Transformed Atlas
% view the landmarks using scatter3
figure
hlA4 = scatter3(lA1_lin_trans(:,1),lA1_lin_trans(:,2),lA1_lin_trans(:,3));
hold on;
hlH4 = scatter3(lH1_lin_trans(:,1),lH1_lin_trans(:,2),lH1_lin_trans(:,3));

% view the surfaces using the patch command
hsA4 = patch('faces',fA1,'vertices',vA1_lin_trans);
hsH4 = patch('faces',fH1,'vertices',vH1_lin_trans);

% fix the axes so x-y-z do not rescale independently
axis image
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
% add a light to visualize 3D surfaces with shading
light
% find a nice orientation
view(64,26)
% color the data to make it more interpretable
% feel free to display it any way you think is best
set(hlA4,'MarkerFaceColor','c','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH4,'MarkerFaceColor','y','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA4,'FaceColor','c','EdgeColor','none','FaceLighting','phong')
set(hsH4,'FaceColor','y','EdgeColor','none','FaceLighting','phong')
% more formatting to make the figure pretty
set(gca,'LineWidth',2,'Box','on','FontSize',12)
legend([hsA4, hsH4], {'Amygdala', 'Hippocampus'}, 'Location', 'best');
% save the figure
set(gcf,'PaperPositionMode','auto')
saveas(gcf,'Atlas Spline Transformed.png')
hold off

%% Visualizing Overlaid Spline Transformed Atlas and Target
% view the landmarks using scatter3
figure
hlA4 = scatter3(lA1_lin_trans(:,1),lA1_lin_trans(:,2),lA1_lin_trans(:,3));
hold on;
hlH4 = scatter3(lH1_lin_trans(:,1),lH1_lin_trans(:,2),lH1_lin_trans(:,3));
hlA2 = scatter3(lA2(:,1),lA2(:,2),lA2(:,3));
hlH2 = scatter3(lH2(:,1),lH2(:,2),lH2(:,3));

% view the surfaces using the patch command
hsA4 = patch('faces',fA1,'vertices',vA1_lin_trans);
hsH4 = patch('faces',fH1,'vertices',vH1_lin_trans);
hsA2 = patch('faces',fA2,'vertices',vA2);
hsH2 = patch('faces',fH2,'vertices',vH2);

% fix the axes so x-y-z do not rescale independently
axis image
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
% add a light to visualize 3D surfaces with shading
light
% find a nice orientation
view(64,26)
% color the data to make it more interpretable
% feel free to display it any way you think is best
set(hlA4,'MarkerFaceColor','c','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH4,'MarkerFaceColor','y','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA4,'FaceColor','c','EdgeColor','none','FaceLighting','phong')
set(hsH4,'FaceColor','y','EdgeColor','none','FaceLighting','phong')
set(hlA2,'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH2,'MarkerFaceColor','g','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA2,'FaceColor','r','EdgeColor','none','FaceLighting','phong')
set(hsH2,'FaceColor','g','EdgeColor','none','FaceLighting','phong')
% more formatting to make the figure pretty
set(gca,'LineWidth',2,'Box','on','FontSize',12)
legend([hsA4, hsH4, hsA2, hsH2], {'A-Amygdala', 'A-Hippocampus', 'T-Amygdala', 'T-Hippocampus'}, 'Location', 'northwest');
% save the figure
set(gcf,'PaperPositionMode','auto')
saveas(gcf,'Overlaid Spline Transformed.png')
hold off
